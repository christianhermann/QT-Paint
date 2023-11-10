# Require Package (Special Rinno version with support for R 4 and higher https://github.com/bschneidr/RInno)
require(RInno)

# Build an installer
create_app(
  app_name = "QT-Paint",
  publisher = "Christian Hermann",
  license_file = "About\\License.txt",
  compression = "bzip",
  info_after = "About\\Contact.txt",
  pkgs = c(
    "shiny",
    "readr",
    "svDialogs",
    "ggthemes",
    "ggplot2",
    "tidyr",
    "latex2exp",
    "colourpicker",
    "ggprism",
    "officer",
    "svglite",
    "esquisse",
    "rChoiceDialogs",
    "shinyFiles"
  ),
  user_browser = "electron",
  app_desc       = "Create pretty current time curve plots",
  app_icon       = "www\\default.ico",
  prog_menu_icon = T,
  desktop_icon   = T)

#Change iss file after:
#Under Icon, change commondesktop to userdesktop.



compile_iss()
