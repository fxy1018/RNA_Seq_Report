library(plotly)

x = c( "orangutans", "monkeys" ,"giraffes")
y = c(14, 23, 20)


data = data.frame(x, y)
data$x <- factor(data$x, levels = data[["x"]])


p <- plot_ly(
  data, x = ~x, y=~y,
  name = "SF Zoo",
  type = "bar"
)

p

x = c("giraffes", "orangutans", "monkeys")
y = c(20, 14, 23)
data2 = data_frame(x,y)
p2 <- plot_ly(
  data2, x = ~x, y=~y,
  name = "SF Zoo",
  type = "bar"
)

p2

data = read.csv("test.csv")
data = data[,-1]
head(data)

# data$experiment = factor(data$experiment, levels=unique(data[["experiment"]]))

# data$condition = factor(data$condition_name, levels=unique(data[["condition_name"]]))

genes = factor(data$gene_name)
genes

data2 = lapply(levels(genes), function(g){
  data[data$gene_name == g, ]
})

names(data2) = levels(genes)

plots = lapply(data2, function(d){
  exp = d$experiment
  plots = lapply(unique(exp), function(e){
    print(e)
    plot_data = d[d$experiment==e,]
    p= plot_ly(plot_data, x = ~factor(condition_name), y = ~expression, name = e, type = "box", boxpoints="all", pointpos=0) %>%
      layout(boxmode = "group", title=plot_data$gene_name[1], xaxis=list(title=e))
    return(p)
  })
})


subplot(c(plots[[1]], plots[[2]]),shareX=F, shareY=F)


p <- plot_ly(data, x = ~condition, y = ~expression, color = ~experiment, type = "box", boxpoints="all", pointpos=0) %>%
  layout(boxmode = "group")
p


x_layout <- list(title="test data x-axis")








