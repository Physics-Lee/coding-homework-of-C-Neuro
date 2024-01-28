next step

* use a for loop to check all the patterns. See if 0.138 emerges or not.
  * 严格来说，我应该在每一次corrupt and recall时都用一个for loop跑遍所有记忆模式。然后重复3-5次这个过程。
  * 目前，我的做法是，跑137次，每次随机选择一个记忆模式。
    * 注：这137次里，如果每次固定选择其中一个记忆模式，error bar图上每个点会是两点分布；如果随机选择一个记忆模式，error bar图上每个点会是正态分布。
      * 两者的$X_i$都是同分布的。（显然）（$X_i$为直方图的横轴）
      * 也就是说，对于前者，虽然每次corrupt的neuron的id是随机的，但是这个随机性不足以让$X_i$独立。
      * 对于后者，$X_i$可以近似为独立的。
  * 两者的结果不会差太多，但前者肯定更好。
* plot fraction of perfect recall versus number of memory patterns, with fraction of corrupt bits fixed.

* track the process of recall, not just the result of recall.


编程

* 生成W这步可以改成向量化编程。

---

这个问题里，噪声来源于

* 生成Pattern时的随机性
* 打乱时的随机性（如果选择fraction_of_corrupt = 0，则这一步没有随机性）

因此，做实验时，应从第一步开始重新生成。

你可以控制这俩，探究它俩对于error-bar的影响。（为了节约时间，我省略了这一步）