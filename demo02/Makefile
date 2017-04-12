R := R CMD BATCH --vanilla


# targets used on Cluster
.PHONY: submit
submit: clusBase.sh clusBase.R simuData.R simuFun.R simuSettings.R
	bash clusBase.sh

.PHONY: batchSubmit
batchSubmit: batchSubmit.sh clusBase.R simuData.R simuFun.R simuSettings.R
	nohup bash batchSubmit.sh > nohup_pid.log 2>&1 &

.PHONY: move
move:
	mv *.RData output/;\
	mv *.condor condors

.PHONY: clean
clean:
	rm -rf *~ err log Rout condors


# targets can be used locally
.PHONY: collect
collect: collect.R
	$(R) collect.R

.PHONY: summary
summary: simuFun.R summar.R
	$(R) summar.R
