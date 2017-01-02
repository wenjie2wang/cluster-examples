################################################################################
### sample function summarizing simulation results
###
### INPUT: RData files in folder named $(inDir)
### naming rule: $(baseName)_$(simuID).RData
### object in RData is named by $(baseName)_$(simuID)
###
### OUTPUT: RData files in folder named $(outDir),
### where the object name is `resDat`
################################################################################


## source functions
source("simuFun.R")
source("simuSettings.R")


## define names
baseName <- "simuID"
inDir <- "fitList"
outDir <- "summary"


## list file names
fileNames <- list.files(inDir,
                        pattern = paste0(baseName, "_[0-9][0-9]*\\.RData"))
simuIDList <- as.numeric(gsub("[^0-9]", replacement = "", fileNames))
fileNames <- fileNames[order(simuIDList)]


## summarize all the results
resList <- lapply(fileNames, function (oneFile) {
    load(paste(inDir, oneFile, sep = "/"))
    oneFile <- gsub("\\.RData", "", oneFile)
    oneRes <- summar(eval(parse(text = oneFile)), sem = TRUE, mi = FALSE)
    rm(list = oneFile)
    oneRes
})
resMat <- cbind(simuID = sort(simuIDList), do.call("rbind", resList))
resDat <- merge(simuSetMat, resMat, by = "simuID")


## save results
if (! dir.exists(outDir)) dir.create(outDir)
outName <- paste0(outDir, "/simuID_", min(simuIDList), "-",
                  max(simuIDList), ".RData")
save(resDat, file = outName)
