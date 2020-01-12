# suppress the scientific notation of numbers

categoryVectorsTable <- read.table("RSAlabassignment/CategoryVectors")
categoryLablesTable <- read.table("RSAlabassignment/CategoryLabels")
neuralResponses <- read.table("RSAlabassignment/NeuralResponses")

# Question 4
# Effect of animacy on the original data's dissimilarity

# RDM for the same & different animacy pairs
row = 92
col = 92
rdm_source <- matrix(0, nrow = row, ncol = col)

for(i in 1:row) {
  for(j in 1:col) {
    if(categoryVectorsTable[i,1] == categoryVectorsTable[j,1]) {
      rdm_source[i, j] = 1
    } else {
      rdm_source[i, j] = 0
    }
  }
}

# Retrieve the non-duplicate data from the lower triangle of RDM without the diagonal data
rdm_lower_triangle_filter <- lower.tri(rdm_source, diag = FALSE)
rdm_unique <- rdm_source[rdm_lower_triangle_filter]

# Retrieve the non-duplicate data for the neural responses
neuralResponses_source <- 1 - cor(t(neuralResponses))
neuralResponses_lower_triangle_filter <- lower.tri(neuralResponses_source, diag = FALSE)
neuralResponses_unique <- neuralResponses_source[neuralResponses_lower_triangle_filter]

# Two groups: one with the same animacy; the other with the different animacy
group_same_animacy <- neuralResponses_unique[rdm_unique[] == 1]
group_diff_animacy <- neuralResponses_unique[rdm_unique[] == 0]

# T-test
t.test(group_same_animacy, group_diff_animacy)

# Question 5

# Effect of animacy on a single subject's dissimilarity
individual_source <- 1 - cor(t(pa_list[[1]]))
individual_lower_triangle_filter <- lower.tri(individual_source, diag = FALSE)
individual_unique <- individual_source[individual_lower_triangle_filter]

ind_group_same_animacy <- individual_unique[rdm_unique[] == 1]
ind_group_diff_animacy <- individual_unique[rdm_unique[] == 0]

t.test(ind_group_same_animacy, ind_group_diff_animacy)

# Effect of animacy on the averaged RDM's dissimilarity
averageRDM_source <- avgPa;
averageRDM_lower_triangle_filter <- lower.tri(averageRDM_source, diag = FALSE)
averageRDM_unique <- averageRDM_source[averageRDM_lower_triangle_filter]

avg_group_same_animacy <- averageRDM_unique[rdm_unique[] == 1]
avg_group_diff_animacy <- averageRDM_unique[rdm_unique[] == 0]

t.test(avg_group_same_animacy, avg_group_diff_animacy)
