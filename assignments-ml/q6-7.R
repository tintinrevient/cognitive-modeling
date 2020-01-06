options(scipen=999)

categoryVectorsTable <- read.table("RSAlabassignment/CategoryVectors")
categoryLablesTable <- read.table("RSAlabassignment/CategoryLabels")
neuralResponses <- read.table("RSAlabassignment/NeuralResponses")

# Question 6 
# Effect of face-ness on the dissimilarity of the original data

# RDM for the same & different face-ness pairs
row = 92
col = 92
rdm_source <- matrix(0, nrow = row, ncol = col)
for(i in 1:row) {
  for(j in 1:col) {
    if(categoryVectorsTable[i,6] == categoryVectorsTable[j,6]) {
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

# Two groups: one with the same face-ness; the other with the different face-ness
group_same_faceness <- neuralResponses_unique[rdm_unique[] == 1]
group_diff_faceness <- neuralResponses_unique[rdm_unique[] == 0]

# T-test
t.test(group_same_faceness, group_diff_faceness)

# Question 7
# Effect of face-ness on the dissimilarity of the animate objects

# RDM for same & different face-ness pairs ONLY in animate objects
# 48 is the boundary between animate and inanimate objects as shown in "CategoryVectors"
row = 48
col = 48
rdm_animate_source <- matrix(0, nrow = row, ncol = col)
for(i in 1:row) {
  for(j in 1:col) {
    if(categoryVectorsTable[i,6] == categoryVectorsTable[j,6]) {
      rdm_animate_source[i, j] = 1
    } else {
      rdm_animate_source[i, j] = 0
    }
  }
}

rdm_animate_lower_triangle_filter <- lower.tri(rdm_animate_source, diag = FALSE)
rdm_animate_unique <- rdm_animate_source[rdm_animate_lower_triangle_filter]

# original data: neural responses for ONLY animate objects
neuralResponses_source <- 1 - cor(t(neuralResponses))
neuralResponses_animate_source <- neuralResponses_source[1:48, 1:48]
neuralResponses_animate_lower_triangle_filter <- lower.tri(neuralResponses_animate_source, diag = FALSE)
neuralResponses_animate_unique <- neuralResponses_animate_source[neuralResponses_animate_lower_triangle_filter]

animate_group_same_faceness <- neuralResponses_animate_unique[rdm_animate_unique[] == 1]
animate_group_diff_faceness <- neuralResponses_animate_unique[rdm_animate_unique[] == 0]

t.test(animate_group_same_faceness, animate_group_diff_faceness)
