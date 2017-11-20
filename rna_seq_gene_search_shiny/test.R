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
