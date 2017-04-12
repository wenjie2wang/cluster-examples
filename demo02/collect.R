################################################################################
### collect results in .RData from each simulated dataset
###
### INPUT: RData files in folder named "output"
### naming rule: $(baseName)_$(simuID)_$(process).RData
### object in RData is named by $(baseName)_$(simuID)_$(process)
###
### OUTPUT: RData files in folder named "fitList"
###
### version controled by git
################################################################################


## define names
inDir <- "output"
outDir <- "fitList"

if (! dir.exists(outDir)) dir.create(outDir)


## list file names
fileNames <- list.files(inDir, pattern = paste0("*_[0-9]+_[0-9]+\\.RData"))
parts <- gsub("_[0-9]+\\.RData", replacement = "", fileNames)
outNames <- unique(parts)
objNames <- gsub("\\.RData", replacement = "", fileNames)


## for each $(simuID) combine all $(process) into a list
for (iter in outNames) {
    idx <- parts %in% iter
    iter2 <- which(idx)
    ## load RData files
    for (j in iter2)
        load(file.path(inDir, fileNames[j]))
    ## determine the range of $(process)
    processes <- sapply(iter2, function(a) {
        gsub(paste0(parts[a], "_"), replacement = "", objNames[a])
    })
    res <- lapply(processes, function(a) {
        objName <- paste(iter, a, sep = "_")
        get(objName)
    })
    assign(iter, res)
    save(list = iter, file = paste0(file.path(outDir, iter), ".RData"))
    rm(list = objNames[idx]); gc()
}
