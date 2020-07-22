#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

################################################################################
# Get significant components
################################################################################

# NOTES
# This finds components significantly activated by, e.g., a contrast and saves it as a 1D file for afni to read

# Read in arguments
annotation_1_1 = args[1]
annotation_1_2 = args[2]
annotation_2_1 = args[3]
annotation_2_2 = args[4]
thresh         = args[5]

pc_dir = grep("_convolved_pvalue_table",grep("$",dir(),value=T),value=T)
components <- as.factor(seq(1,length(pc_dir)))
p_value_table <- matrix(nrow=length(as.matrix(read.table(paste(annotation_1_1,"_",annotation_1_2,"_",annotation_2_1,"_",annotation_2_2,"_convolved_pvalue_table_ic1",sep=""),header=FALSE))), ncol=length(components))
p_value_table_thresh <- matrix(nrow=length(as.matrix(read.table(paste(annotation_1_1,"_",annotation_1_2,"_",annotation_2_1,"_",annotation_2_2,"_convolved_pvalue_table_ic1",sep=""),header=FALSE))), ncol=length(components))

for (component in levels(components)) {
p_value_table[,as.numeric(paste(component))] <- as.matrix(read.table(paste(annotation_1_1,"_",annotation_1_2,"_",annotation_2_1,"_",annotation_2_2,"_convolved_pvalue_table_ic",component,sep=""),header=FALSE))
}

p_value_table_thresh[p_value_table<=as.numeric(paste(".",thresh,sep=""))]<-1
p_value_table_thresh[p_value_table>as.numeric(paste(".",thresh,sep=""))]<-0

crit_components <- c(1,2,3,4,5,6,7,8)
for (crit_component in crit_components) {
    components_crit <- which(p_value_table_thresh[as.numeric(crit_component),]==1)
    awes_components <- matrix(nrow=length(components_crit), ncol=2)
    i<-1
    for (fun_component in components_crit) {
        awes_components[i,1]<-as.numeric(fun_component)
        awes_components[i,2]<-as.numeric(sum(as.numeric(p_value_table_thresh[,as.numeric(fun_component)])))
        i<-i+1
    }
    if (crit_component == 1) {
        write.table(awes_components[,1],paste(annotation_1_1,".1D",sep=""),row.name = FALSE, col.name = FALSE, append = FALSE)
    }
    if (crit_component == 2) {
        write.table(awes_components[,1],paste(annotation_1_2,".1D",sep=""),row.name = FALSE, col.name = FALSE, append = FALSE)
    }
    if (crit_component == 3) {
        write.table(awes_components[,1],paste(annotation_2_1,".1D",sep=""),row.name = FALSE, col.name = FALSE, append = FALSE)
    }
    if (crit_component == 4) {
        write.table(awes_components[,1],paste(annotation_2_2,".1D",sep=""),row.name = FALSE, col.name = FALSE, append = FALSE)
    }
    if (crit_component == 5) {
        write.table(awes_components[,1],paste(annotation_1_1,"_vs_",annotation_1_2,".1D",sep=""),row.name = FALSE, col.name = FALSE, append = FALSE)
    }
    if (crit_component == 6) {
        write.table(awes_components[,1],paste(annotation_1_2,"_vs_",annotation_1_1,".1D",sep=""),row.name = FALSE, col.name = FALSE, append = FALSE)
    }
    if (crit_component == 7) {
        write.table(awes_components[,1],paste(annotation_2_1,"_vs_",annotation_2_2,".1D",sep=""),row.name = FALSE, col.name = FALSE, append = FALSE)
    }
    if (crit_component == 8) {
        write.table(awes_components[,1],paste(annotation_2_2,"_vs_",annotation_2_1,".1D",sep=""),row.name = FALSE, col.name = FALSE, append = FALSE)
    }
}

################################################################################
# END
################################################################################
