#pragma once

#if defined(WINAPI_FAMILY) && (WINAPI_FAMILY != WINAPI_FAMILY_DESKTOP_APP)
#ifdef __cplusplus
extern "C" {
    void* ass_uwp_get_dwritecreatefactory()
}
#endif
#endif


