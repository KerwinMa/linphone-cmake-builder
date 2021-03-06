############################################################################
# xml2.cmake
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

if(LINPHONE_BUILDER_PREBUILT_URL)
	set(EP_xml2_FILENAME "xml2-v2.8.0-${LINPHONE_BUILDER_ARCHITECTURE}.zip")
	file(DOWNLOAD "${LINPHONE_BUILDER_PREBUILT_URL}/${EP_xml2_FILENAME}" "${CMAKE_CURRENT_BINARY_DIR}/${EP_xml2_FILENAME}" STATUS EP_xml2_FILENAME_STATUS)
	list(GET EP_xml2_FILENAME_STATUS 0 EP_xml2_DOWNLOAD_STATUS)
	if(NOT EP_xml2_DOWNLOAD_STATUS)
		set(EP_xml2_PREBUILT 1)
	endif()
endif()

if(EP_xml2_PREBUILT)
	set(EP_xml2_URL "${CMAKE_CURRENT_BINARY_DIR}/${EP_xml2_FILENAME}")
	set(EP_xml2_BUILD_METHOD "prebuilt")
else()
	set(EP_xml2_GIT_REPOSITORY "git://git.gnome.org/libxml2")
	set(EP_xml2_GIT_TAG "v2.8.0")
	set(EP_xml2_LINKING_TYPE "-DENABLE_STATIC=0")
	set(EP_xml2_PATCH_COMMAND "${CMAKE_COMMAND}" "-E" "copy" "${CMAKE_CURRENT_SOURCE_DIR}/builders/xml2/CMakeLists.txt" "<SOURCE_DIR>")
	set(EP_xml2_PATCH_COMMAND "${EP_xml2_PATCH_COMMAND}" "COMMAND" "${CMAKE_COMMAND}" "-E" "copy" "${CMAKE_CURRENT_SOURCE_DIR}/builders/xml2/config.h.cmake" "<SOURCE_DIR>")
endif()
