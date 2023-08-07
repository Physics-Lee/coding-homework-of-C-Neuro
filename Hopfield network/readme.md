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

---

“高斯开始从误差的分析入手，他假设误差是由许多小因素引起的，每个小因素都有可能的正误差或负误差，并且没有一个因素的影响特别大。”

这些小误差是独立的没什么问题，但是它们不太可能是同分布的，因此不能用中心极限定理。

---

我听说，自然界中，只要某个随机变量的影响因素较多（比如人的身高），这个随机变量的分布就会是正态分布，这句话对吗？