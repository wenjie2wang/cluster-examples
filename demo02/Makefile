R := R CMD BATCH --vanilla


# targets can be used on Cluster
.PHONY: submit move clean
submit: clusBase.sh clusBase.R simuData.R simuFun.R simuSettings.R
	bash clusBase.sh

move:
	mv *.RData output/;\
	mv *.condor condors

clean:
	rm -rf *~ err log Rout condors


# targets can be used locally
.PHONY: collect
collect: collect.R
	$(R) collect.R

.PHONY: summary
summary: simuFun.R summar.R
	$(R) summar.R
