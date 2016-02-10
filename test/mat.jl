#println(typeof(SimplePlot.pyplot(grid(1,1,axis(heatmap(rand(10,10)))))))
save("tmp.png", matplot(rand(10,10)))

axis(
    matplot(rand(10,10)),
    matplot(rand(10,10))
)
