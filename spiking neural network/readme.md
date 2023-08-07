小冼真的很聪明！

生成泊松过程

* 我的做法：搞了一个1000*10000的巨大无比的cell array。
* 小冼的做法：一小步一小步地去处理。

最绝的是

```matlab
P = rate * dt;
n_firing_neuron = rand(1,num) < P;
```

她用这种方法直接选出了那些在fire的neuron！