# a

![stimulus_before_spikes_all](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\stimulus_before_spikes_all.png)



![stimulus_before_spikes_long_interval](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\stimulus_before_spikes_long_interval.png)



![stimulus_before_spikes_short_interval](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\stimulus_before_spikes_short_interval.png)



# b

![real_vs_predict_linear](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\real_vs_predict_linear.png)

![real_vs_predict_ReLU](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\real_vs_predict_ReLU.png)

![real_vs_predict_ReLU_with_up_bound](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\real_vs_predict_ReLU_with_up_bound.png)

![real_vs_predict_Sigmoid](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\real_vs_predict_Sigmoid.png)



# c

all intervals

![test_Poisson_all](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\test_Poisson_all.png)

drop intervals which are shorter than 20ms

![test_Poisson_screened](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\test_Poisson_screened.png)

ideal

![test_Poisson_ideal](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\test_Poisson_ideal.png)



# d

Why is there a dip below 6 ms in the histogram for the actual spike train?: Refactory.

![hist_isi_real](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\hist_isi_real.png)

![hist_isi_ideal](D:\Public_repository\coding-homework-of-C-Neuro\electrophysiological data of H1 cell of the fly\result\hist_isi_ideal.png)

What are the coefficents of variation (see lecture note) for the two spike trains and why might they differ?: Real data has bigger $\sigma$.

```matlab
isi real
Mean: 0.0224
Standard Deviation: 0.0450
Coefficient of Variation: 2.0086

isi ideal
Mean: 0.0223
Standard Deviation: 0.0223
Coefficient of Variation: 1.0019
```

Why is there a dip at a lag of 2 ms in the autocorrelation of the actual spike train? Refactory.

Is there a dip for the synthetic train too? No.

The histogram of inter-spike-interval tells us, compared with ideal Poisson process, the real spike train has:

* Less 0-6 ms
* More 6-20 ms
* Similar 20-Inf ms

This leads to that, in the plot of auto-corr

* 0-6 ms is smaller than 6-20 ms
* 2 ms is smaller than 0.
* 20-Inf ms is similar

**So, always remember to plot the histogram!**



**![auto_corr_by_autocorr](README.assets/auto_corr_by_autocorr.png)**