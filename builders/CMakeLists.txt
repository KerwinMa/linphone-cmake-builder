############################################################################
# CMakeLists.txt
# Copyright (C) 2014  Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
############################################################################

if(LINPHONE_BUILDER_CHECK_LATEST)

	find_package(Git)

	file(GLOB _builders RELATIVE ${CMAKE_CURRENT_LIST_DIR} "${CMAKE_CURRENT_LIST_DIR}/*.cmake")
	list(SORT _builders)
	foreach(_builder ${_builders})
		include("${CMAKE_CURRENT_LIST_DIR}/${_builder}")
		get_filename_component(_builder_name ${_builder} NAME_WE)
		if(EP_${_builder_name}_GIT_TAG_LATEST)
			execute_process(COMMAND "${GIT_EXECUTABLE}" "ls-remote" "${EP_${_builder_name}_GIT_REPOSITORY}" "${EP_${_builder_name}_GIT_TAG_LATEST}"
				OUTPUT_FILE "${LINPHONE_BUILDER_WORK_DIR}/EP_${_builder_name}_git_latest")
			execute_process(COMMAND "head" "-n1" "${LINPHONE_BUILDER_WORK_DIR}/EP_${_builder_name}_git_latest"
				OUTPUT_VARIABLE _builder_latest)
			string(REPLACE "\t" ";" _builder_latest ${_builder_latest})
			list(GET _builder_latest 0 _builder_latest_git_tag)
			if("${EP_${_builder_name}_GIT_TAG}" STREQUAL "${_builder_latest_git_tag}")
				message(STATUS "${_builder_name} is up-to-date")
			else()
				message(STATUS "${_builder_name} is outdated: ${EP_${_builder_name}_GIT_TAG} instead of ${_builder_latest_git_tag} [${EP_${_builder_name}_GIT_TAG_LATEST}]")
			endif()
		else()
			message(STATUS "${_builder_name} is up-to-date")
		endif()
	endforeach()

else()

	# Include linphone builder options definitions
	include(cmake/LinphoneBuilderOptions.cmake)

	add_custom_target(TARGET_linphone_builder ALL)

	# Build belle-sip and its dependencies if it is in the targets list
	list(FIND LINPHONE_BUILDER_TARGETS "belle-sip" _target_found)
	if(_target_found GREATER -1)
		add_custom_target(TARGET_bellesip ALL)
		add_dependencies(TARGET_linphone_builder TARGET_bellesip)
		linphone_builder_add_builder_to_target(TARGET_bellesip antlr3c)
		linphone_builder_add_builder_to_target(TARGET_bellesip polarssl)
		if(ENABLE_UNIT_TESTS)
			linphone_builder_add_builder_to_target(TARGET_bellesip cunit)
		endif()
		if(ENABLE_TUNNEL)
			linphone_builder_add_builder_to_target(TARGET_bellesip tunnel)
		endif()
		linphone_builder_add_builder_to_target(TARGET_bellesip bellesip)
	endif()


	# Build ortp and its dependencies if it is in the targets list
	list(FIND LINPHONE_BUILDER_TARGETS "ortp" _target_found)
	if(_target_found GREATER -1)
		add_custom_target(TARGET_ortp ALL)
		add_dependencies(TARGET_linphone_builder TARGET_ortp)
		if(ENABLE_UNIT_TESTS)
			linphone_builder_add_builder_to_target(TARGET_ortp cunit)
		endif()
		linphone_builder_add_builder_to_target(TARGET_ortp ortp)
	endif()


	# Build mediastreamer2 and its dependencies if it is in the targets list
	list(FIND LINPHONE_BUILDER_TARGETS "ms2" _target_found)
	if(_target_found GREATER -1)
		add_custom_target(TARGET_ms2 ALL)
		add_dependencies(TARGET_linphone_builder TARGET_ms2)
		add_dependencies(TARGET_ms2 TARGET_ortp)
		if(ENABLE_UNIT_TESTS)
			linphone_builder_add_builder_to_target(TARGET_ms2 cunit)
		endif()
		if(ENABLE_GSM)
			linphone_builder_add_builder_to_target(TARGET_ms2 gsm)
		endif()
		if(ENABLE_OPUS)
			linphone_builder_add_builder_to_target(TARGET_ms2 opus)
		endif()
		if(ENABLE_SPEEX)
			linphone_builder_add_builder_to_target(TARGET_ms2 speex)
		endif()
		if(ENABLE_FFMPEG)
			linphone_builder_add_builder_to_target(TARGET_ms2 ffmpeg)
		endif()
		if(ENABLE_VPX)
			linphone_builder_add_builder_to_target(TARGET_ms2 vpx)
		endif()
		if(ENABLE_V4L)
			linphone_builder_add_builder_to_target(TARGET_ms2 v4l)
		endif()
		if(ENABLE_SRTP)
			linphone_builder_add_builder_to_target(TARGET_ms2 srtp)
		endif()
		if(ENABLE_ZRTP)
			linphone_builder_add_builder_to_target(TARGET_ms2 polarssl)
			linphone_builder_add_builder_to_target(TARGET_ms2 xml2)
			linphone_builder_add_builder_to_target(TARGET_ms2 bzrtp)
		endif()
		linphone_builder_add_builder_to_target(TARGET_ms2 ms2)
	endif()


	# Build mediastreamer2 plugins and its dependencies if it is in the targets list
	list(FIND LINPHONE_BUILDER_TARGETS "ms2-plugins" _target_found)
	if(_target_found GREATER -1)
		add_custom_target(TARGET_ms2plugins ALL)
		add_dependencies(TARGET_linphone_builder TARGET_ms2plugins)
		add_dependencies(TARGET_ms2plugins TARGET_ms2 TARGET_ortp)
		if(ENABLE_AMRNB OR ENABLE_AMRWB)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins opencoreamr)
		endif()
		if(ENABLE_AMRWB)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins voamrwbenc)
		endif()
		if(ENABLE_AMRNB OR ENABLE_AMRWB)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins msamr)
		endif()
		if(ENABLE_G729)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins bcg729)
		endif()
		if(ENABLE_ILBC)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins libilbcrfc3951)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins msilbc)
		endif()
		if(ENABLE_ISAC OR ENABLE_WEBRTC_AEC)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins mswebrtc)
		endif()
		if(ENABLE_SILK)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins mssilk)
		endif()
		if(ENABLE_OPENH264)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins openh264)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins msopenh264)
		endif()
		if(ENABLE_X264)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins x264)
			linphone_builder_add_builder_to_target(TARGET_ms2plugins msx264)
		endif()
	endif()


	# Build linphone and its dependencies if it is in the targets list
	list(FIND LINPHONE_BUILDER_TARGETS "linphone" _target_found)
	if(_target_found GREATER -1)
		add_custom_target(TARGET_linphone ALL)
		add_dependencies(TARGET_linphone_builder TARGET_linphone)
		add_dependencies(TARGET_linphone TARGET_bellesip TARGET_ortp TARGET_ms2)
		linphone_builder_add_builder_to_target(TARGET_linphone sqlite3)
		linphone_builder_add_builder_to_target(TARGET_linphone xml2)
		if(ENABLE_UNIT_TESTS)
			linphone_builder_add_builder_to_target(TARGET_linphone cunit)
		endif()
		if(ENABLE_TUNNEL)
			linphone_builder_add_builder_to_target(TARGET_linphone tunnel)
		endif()
		linphone_builder_add_builder_to_target(TARGET_linphone linphone)
	endif()

	# Build flexisip and its dependencies if it is in the targets list
	list(FIND LINPHONE_BUILDER_TARGETS "flexisip" _target_found)
	if(_target_found GREATER -1)
		add_custom_target(TARGET_flexisip ALL)
		add_dependencies(TARGET_linphone_builder TARGET_flexisip)
		add_dependencies(TARGET_flexisip TARGET_ortp )

		if( USE_BC_ODBC )
			linphone_builder_add_builder_to_target(TARGET_flexisip unixodbc )
			linphone_builder_add_builder_to_target(TARGET_flexisip myodbc )
		endif()
		linphone_builder_add_builder_to_target(TARGET_flexisip sofiasip )

		linphone_builder_add_builder_to_target(TARGET_flexisip odb )
		linphone_builder_add_builder_to_target(TARGET_flexisip libodb )
		linphone_builder_add_builder_to_target(TARGET_flexisip libodbmysql )
		
		linphone_builder_add_builder_to_target(TARGET_flexisip flexisip )
	endif()

endif()
