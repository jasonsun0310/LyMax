
macro(CheckLoadErrors lyxerrx PARAMS_DIR res_erg)
  set(lyxerr ${${lyxerrx}})
  set(_erg 0)
  if(lyxerr)
    set(ConfigureOutput 0)
    set(DocumentClassNotAvailable 0)
    file(STRINGS "${PARAMS_DIR}/filterCheckWarnings" ignoreRegexp)
    # Split lyxerr into lines
    string(REGEX REPLACE "[\n]+" ";" foundErrors ${lyxerr})
    foreach(_l ${foundErrors})
      if(ConfigureOutput)
        if(_l MATCHES "LyX: Done!")
          set(ConfigureOutput 0)
        endif()
      elseif(DocumentClassNotAvailable)
      	if(_l MATCHES "User's Guide for more information.")
	  set(DocumentClassNotAvailable 0)
	endif()
      else()
        if(_l MATCHES "reconfiguring user directory")
          set(ConfigureOutput 1)
	elseif(_l MATCHES "Warning: Document class not available")
	  set(DocumentClassNotAvailable 1)
	else()
	  # here neither ConfigureOutput nor DocumentClassNotAvailable is set
	  # so we can scan for other warnings/errors
	  set(found 0)
	  foreach(_r ${ignoreRegexp})
	    if(_l MATCHES "${_r}")
	      set(found 1)
	      break()
	    endif()
	  endforeach()
	  if(NOT found)
	    message(STATUS "Error line = ${_l}")
	    # It is error, because the error-line does not match
	    # any ignoring expression
	    set(_erg 1)
	  endif()
        endif()
      endif()
    endforeach()
  endif()
  set(${res_erg} ${_erg})
endmacro()
