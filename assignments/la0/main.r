x <- 6
v <- c(1,2,3)
nv <- v * x
print(nv)

check <- TRUE
while(check)
{
  for (i in unique(seq(1,20,1)))
  {
    if(i < 12)
    {
      if (i %% 2 == 0)
      {
        print(c(i, i+1))
      }
    }
    else
    {
      check <- FALSE
    }
  }
}


mysteryFunction	<- function(digit,add)
{
  result	<- digit	+	add
  result
}
slicerFunction	<- function(digit,criterion=5)
{
  result	<- digit[digit<criterion]
  result
}
test	<- c(4,5,6,7,8,7,6,5,4,3,2,1)
slicerFunction(test)
slicerFunction(test,8)
mysteryFunction(test,5)


countCount <- function(numNum){
  for(x in seq(1, length(numNum))){
    numNum[x] <- numNum[x] + x
  }
  numNum
}
countCount(4)
countCount(numNum=4)
countCount(c(4,10))
countCount(1:10)
countCount(10:1)

require(ggplot2)
qplot(c(4.3,5.2,6.9),c(10.1,11.2,11.9),xlab="x	label",	ylab="y	label")

plot(seq(0,10,1),seq(0,10,1),pch=20,col=1)
lines(c(0,10),c(10,0),col=3)
points(rnorm(15,5,0.5),rnorm(15,4,0.5),col=2,pch=20)
text(5,9, "test")
quartz()
par(mfrow=c(2,3))
plot(5,6)

a <- 0:9
b <- seq(0,0.9,0.1)
ind <- rep(c("A","B"),length(a)/2)
indAlt <- c(rep("C",length(a)/2),rep("D",length(a)/2))
frameFrame <- data.frame(index1=ind,index2=indAlt,a,b)

names(frameFrame)
frameFrame$index1
frameFrame$index2
dim(frameFrame)
frameFrame[1:5,]
frameFrame[,1:2]
frameFrame[frameFrame$index1 == "A",]
frameFrame[frameFrame$index1 == "A",]$b

frameFrame$c	<- "test"
frameFrame$d	<- frameFrame$a	%%2
frameFrame$diffa	<- c(0, diff(frameFrame$a))
frameFrame$diffb <- c(0, diff(frameFrame$b))
frameFrame$diffd <- c(0, diff(frameFrame$d))

mean(frameFrame$a)
summary(frameFrame$a)
summary(frameFrame)
levels(frameFrame$index1)

with(frameFrame,tapply(a,list(index1,index2),median))
with(frameFrame,aggregate(a,list(l1=index1,l2=index2),median))
with(frameFrame[frameFrame$index2	== "C",],aggregate(a,list(l1=index1,l2=index2),median))

fast	<- rnorm(20,200,10)
slow	<- rnorm(20,400,10)
t.test(fast, slow)
