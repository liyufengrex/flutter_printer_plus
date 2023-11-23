//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <r_get_ip/r_get_ip_plugin.h>
#include <windows_usb_printer/windows_usb_printer_provider.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  RGetIpPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RGetIpPlugin"));
  WindowsUsbPrinterProviderRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowsUsbPrinterProvider"));
}
