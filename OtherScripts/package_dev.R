#Package development

library(devtools)

document()
load_all()
build()

install()

.rs.restartR()
library("WeekendSpecial")


check()

#Call new GetSites function to get site locations as df; must reference OU of interest by UID and site level by #
datimvalidation::loadSecrets(secrets = NA)
df <- wpm_getcoords("cDGPF739ZZr", 7, "GIS")

