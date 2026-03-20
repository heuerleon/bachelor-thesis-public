#import "../../pages/outline.typ": custom_caption

#show table.cell.where(y: 0): it => strong(delta: 200, it)
#set table(stroke: .5pt + black)

=== Use Case 1 <usecase1-time-appendix>

#grid(
  columns: (1fr, 1fr),
  [#figure(
    image("../../res/usecase1/results/density.svg"),
    caption: custom_caption(
      [Time density of use case 1 benchmark. The x-axis shows the time in milliseconds, while the y-axis shows the density. A distribution of execution time can be seen, including a marker for the average time. The distribution is concentrated around the average time, with a few outliers around 3.2ms.],
      [Use Case 1 - Time density distribution plot and average],
    ),
  ) <usecase1-density>],
  [#figure(
    image("../../res/usecase1/results/regression.svg"),
    caption: custom_caption(
      [Total sample time per iteration of use case 1 benchmark. The x-axis shows the iteration number, while the y-axis shows sample time in seconds. A linear regression line can be seen that fits the data points. The data points become slightly more spread towards the end, and there is one outlier at around x = 1.05, y = 3.5.],
      [Use Case 1 - Total sample time plot and linear regression],
    ),
  ) <usecase1-regression>],
)

#v(3em)

#figure(
  table(
    columns: 4,
    [Metric], [Lower bound], [Estimate], [Upper bound],
    [Slope], [2.7942 ms], [2.8134 ms], [2.8373 ms],
    [R²], [0.8690985], [0.8740415], [0.8663407],
    [Mean], [2.8502 ms], [2.8714 ms], [2.8944 ms],
    [Std. Dev.], [80.703 µs], [111.68 µs], [140.10 µs],
    [Median], [2.8537 ms], [2.8639 ms], [2.8698 ms],
    [MAD], [50.362 µs], [75.196 µs], [104.83 µs],
    [Change in time], [-2.8563%], [-1.8605%], [-0.7604%],
  ),
  caption: custom_caption(
    [Statistical estimations and confidence intervals for use case 1. The lower bound, point estimate and upper bound of each measure are displayed. The change in time was reported as statistically significant, but within the noise threshold by the tool Criterion. The $R^2$ value indicates that the regression model fits well, but is slightly lower due to the spread out data points towards the end.],
    [Use Case 1 - Complete statistical estimations and confidence intervals],
  ),
)

=== Use Case 2 <usecase2-time-appendix>

#grid(
  columns: (1fr, 1fr),
  [#figure(
    image("../../res/usecase2/results/density.svg"),
    caption: custom_caption(
      [Time density of use case 2 benchmark. The x-axis shows the time in milliseconds, while the y-axis shows the density. A distribution of execution time can be seen, including a marker for the average time. The distribution is concentrated a bit to the left of the average time, and the distribution is stretched out to the right at a lower level.],
      [Use Case 2 - Time density distribution plot and average],
    ),
  ) <usecase2-density>],
  [#figure(
    image("../../res/usecase2/results/regression.svg"),
    caption: custom_caption(
      [Total sample time per iteration of use case 2 benchmark. The x-axis shows the iteration number, while the y-axis shows sample time in seconds. A linear regression line can be seen that fits the data points. A few data points are slightly higher than the regression line between x = 230 and x = 300.],
      [Use Case 2 - Total sample time plot and linear regression],
    ),
  ) <usecase2-regression>],
)

#v(3em)

#figure(
  table(
    columns: 4,
    [Metric], [Lower bound], [Estimate], [Upper bound],
    [Slope], [8.7232 µs], [8.7503 µs], [8.7831 µs],
    [R²], [0.9623165], [0.9636155], [0.9617049],
    [Mean], [8.7387 µs], [8.7691 µs], [8.8016 µs],
    [Std. Dev.], [130.17 ns], [161.20 ns], [186.87 ns],
    [Median], [8.6884 µs], [8.7025 µs], [8.7360 µs],
    [MAD], [65.199 ns], [87.682 ns], [130.32 ns],
    [Change in time], [+0.9048%], [+1.2524%], [+1.6533%],
  ),
  caption: custom_caption(
    [Statistical estimations and confidence intervals for use case 2. The lower bound, point estimate and upper bound of each measure are displayed. The change in time was reported as statistically significant, but within the noise threshold by the tool Criterion. The $R^2$ value indicates that the regression model fits well.],
    [Use Case 2 - Complete statistical estimations and confidence intervals],
  ),
)

=== Use Case 3 <usecase3-time-appendix>

#grid(
  columns: (1fr, 1fr),
  [#figure(
    image("../../res/usecase3/results/density.svg"),
    caption: custom_caption(
      [Time density of use case 3 benchmark. The x-axis shows the time in milliseconds, while the y-axis shows the density. A distribution of execution time can be seen, including a marker for the average time. The distribution is centered around the average time, but its peak lies left of the average.],
      [Use Case 3 - Time density distribution plot and average],
    ),
  ) <usecase3-density>],
  [#figure(
    image("../../res/usecase3/results/regression.svg"),
    caption: custom_caption(
      [Total sample time per iteration of use case 3 benchmark. The x-axis shows the iteration number, while the y-axis shows sample time in seconds. A linear regression line can be seen that doesn't fit the data points well. The data points follow a nonlinear, steady increase, possibly indicating a superlinear growth.],
      [Use Case 3 - Total sample time plot and linear regression],
    ),
  ) <usecase3-regression>],
)

#v(3em)

#figure(
  table(
    columns: 4,
    [Metric], [Lower bound], [Estimate], [Upper bound],
    [Slope], [21.059 ms], [22.096 ms], [22.978 ms],
    [R²], [0.3526551], [0.3677720], [0.3566953],
    [Mean], [17.015 ms], [17.926 ms], [18.858 ms],
    [Std. Dev.], [4.2030 ms], [4.7230 ms], [5.1472 ms],
    [Median], [15.490 ms], [16.900 ms], [18.423 ms],
    [MAD], [3.8419 ms], [5.3993 ms], [6.7121 ms],
    [Change in time], [-10.668%], [-3.6920%], [+3.8755%],
  ),
  caption: custom_caption(
    [Statistical estimations and confidence intervals for use case 3. The lower bound, point estimate and upper bound of each measure are displayed. The change in time was reported as statistically insignificant by the tool Criterion, with the lower and upper bound being relatively far apart, possibly due to the low $R^2$ value. It indicates that the linear regression model doesn't fit the data points well, which is due to the nonlinear progression. This is also a possible reason for the high standard deviation of around 4.7ms, when compared to the mean of around 17.9ms.],
    [Use Case 3 - Complete statistical estimations and confidence intervals],
  ),
)
