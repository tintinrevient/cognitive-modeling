library(tidyverse)
library(lattice)
library(viridisLite)
library(gridExtra)

categoryVectorsTable <- read.table("CategoryVectors")
categoryLablesTable <- read.table("CategoryLabels")
neuralResponses <- read.table("NeuralResponses")

View(categoryVectorsTable)
View(categoryLablesTable)

# animacy
options(scipen=999)

# rdm for same & diff animacy pairs
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
View(rdm_source)

rdm_lower_triangle_filter <- lower.tri(rdm_source, diag = FALSE)
rdm_unique <- rdm_source[rdm_lower_triangle_filter]
View(rdm_unique)

# original data: neural responses
neuralResponses_source <- 1 - cor(t(neuralResponses))
neuralResponses_lower_triangle_filter <- lower.tri(neuralResponses_source, diag = FALSE)
neuralResponses_unique <- neuralResponses_source[neuralResponses_lower_triangle_filter]
View(neuralResponses_unique)

group_same_animacy <- neuralResponses_unique[rdm_unique[] == 1]
group_diff_animacy <- neuralResponses_unique[rdm_unique[] == 0]
View(group_same_animacy)
View(group_diff_animacy)

t.test(group_same_animacy, group_diff_animacy)

# individual data
individual_source <- 1 - cor(t(pp_list[[1]]))
individual_lower_triangle_filter <- lower.tri(individual_source, diag = FALSE)
individual_unique <- individual_source[individual_lower_triangle_filter]
View(individual_unique)

ind_group_same_animacy <- individual_unique[rdm_unique[] == 1]
ind_group_diff_animacy <- individual_unique[rdm_unique[] == 0]
View(ind_group_same_animacy)
View(ind_group_diff_animacy)

t.test(ind_group_same_animacy, ind_group_diff_animacy)

# average data
averageRDM_source <- avgPP;
averageRDM_lower_triangle_filter <- lower.tri(averageRDM_source, diag = FALSE)
averageRDM_unique <- averageRDM_source[averageRDM_lower_triangle_filter]
View(averageRDM_unique)

group_same_animacy <- averageRDM_unique[rdm_unique[] == 1]
group_diff_animacy <- averageRDM_unique[rdm_unique[] == 0]
View(group_same_animacy)
View(group_diff_animacy)

t.test(group_same_animacy, group_diff_animacy)


# faceness
options(scipen=999)

# rdm for same & diff face-ness pairs
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
View(rdm_source)

rdm_lower_triangle_filter <- lower.tri(rdm_source, diag = FALSE)
rdm_unique <- rdm_source[rdm_lower_triangle_filter]
View(rdm_unique)

# original data: neural responses
neuralResponses_source <- 1 - cor(t(neuralResponses))
neuralResponses_lower_triangle_filter <- lower.tri(neuralResponses_source, diag = FALSE)
neuralResponses_unique <- neuralResponses_source[neuralResponses_lower_triangle_filter]
View(neuralResponses_unique)

group_same_faceness <- neuralResponses_unique[rdm_unique[] == 1]
group_diff_faceness <- neuralResponses_unique[rdm_unique[] == 0]
View(group_same_faceness)
View(group_diff_faceness)

t.test(group_same_faceness, group_diff_faceness)

# only animate subjects for face-ness

# rdm for same & diff face-ness pairs ONLY in animate objects
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
View(rdm_animate_source)

rdm_animate_lower_triangle_filter <- lower.tri(rdm_animate_source, diag = FALSE)
rdm_animate_unique <- rdm_animate_source[rdm_animate_lower_triangle_filter]
View(rdm_animate_unique)

# original data: neural responses
neuralResponses_source <- 1 - cor(t(neuralResponses))
neuralResponses_animate_source <- neuralResponses_source[1:48, 1:48]
neuralResponses_animate_lower_triangle_filter <- lower.tri(neuralResponses_animate_source, diag = FALSE)
neuralResponses_animate_unique <- neuralResponses_animate_source[neuralResponses_animate_lower_triangle_filter]
View(neuralResponses_animate_unique)

group_same_faceness <- neuralResponses_animate_unique[rdm_animate_unique[] == 1]
group_diff_faceness <- neuralResponses_animate_unique[rdm_animate_unique[] == 0]
View(group_same_faceness)
View(group_diff_faceness)

t.test(group_same_faceness, group_diff_faceness)

# human

# rdm for same & diff human pairs
row = 92
col = 92
rdm_source <- matrix(0, nrow = row, ncol = col)
for(i in 1:row) {
  for(j in 1:col) {
    if(categoryVectorsTable[i,3] == categoryVectorsTable[j,3]) {
      rdm_source[i, j] = 1
    } else {
      rdm_source[i, j] = 0
    }
  }
}
View(rdm_source)

rdm_lower_triangle_filter <- lower.tri(rdm_source, diag = FALSE)
rdm_unique <- rdm_source[rdm_lower_triangle_filter]
View(rdm_unique)

# original data: neural responses
neuralResponses_source <- 1 - cor(t(neuralResponses))
neuralResponses_lower_triangle_filter <- lower.tri(neuralResponses_source, diag = FALSE)
neuralResponses_unique <- neuralResponses_source[neuralResponses_lower_triangle_filter]
View(neuralResponses_unique)

group_same_human <- neuralResponses_unique[rdm_unique[] == 1]
group_diff_human <- neuralResponses_unique[rdm_unique[] == 0]
View(group_same_human)
View(group_diff_human)

t.test(group_same_human, group_diff_human)


# rdm for same & diff human pairs ONLY in animate objects
row = 48
col = 48
rdm_animate_source <- matrix(0, nrow = row, ncol = col)
for(i in 1:row) {
  for(j in 1:col) {
    if(categoryVectorsTable[i,3] == categoryVectorsTable[j,3]) {
      rdm_animate_source[i, j] = 1
    } else {
      rdm_animate_source[i, j] = 0
    }
  }
}
View(rdm_animate_source)

rdm_animate_lower_triangle_filter <- lower.tri(rdm_animate_source, diag = FALSE)
rdm_animate_unique <- rdm_animate_source[rdm_animate_lower_triangle_filter]
View(rdm_animate_unique)

# original data: neural responses
neuralResponses_source <- 1 - cor(t(neuralResponses))
neuralResponses_animate_source <- neuralResponses_source[1:48, 1:48]
neuralResponses_animate_lower_triangle_filter <- lower.tri(neuralResponses_animate_source, diag = FALSE)
neuralResponses_animate_unique <- neuralResponses_animate_source[neuralResponses_animate_lower_triangle_filter]
View(neuralResponses_animate_unique)

group_same_human <- neuralResponses_animate_unique[rdm_animate_unique[] == 1]
group_diff_human <- neuralResponses_animate_unique[rdm_animate_unique[] == 0]
View(group_same_human)
View(group_diff_human)

t.test(group_same_human, group_diff_human)

animate <- categoryVectorsTable[1:48, c(1, 3, 6, 12)]
inanimate <- categoryVectorsTable[49:92, c(1, 3, 6, 12)]
View(animate)
View(inanimate)








