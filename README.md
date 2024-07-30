RefMe - Patient Referral Scheduler

Kaui Lebarbenchon, Daniel Yao
30 July 2024

Let $n \in \mathbb{N}$ enumerate the patients. Let $h$ enumerate the times a patient may be seen. Let $x_{nh}$ be the indicator that is $1$ if patient is seen at time $h$ and is $0$ otherwise. Let $p_{nh}$ be the penalty for not seeing patient $n$ on or before time $h$. (For all $h$ on and after patient n is seen, $p_{nh} = 0$. We minimize 

$$\sum_{n \in N}\sum_{h \in H}p_{nh}(1 - x_{nh})$$

subject to the constraints

$$\sum_{h \in H}x_{nh} = 1$$

for all $n \in N$ and 

$$\sum_{n \in N}x_{nh} \leq 1$$

for all $h \in H$. These two constraints specify that (1) a patient must be seen exactly once in the time horizon and (2) each time may be occupied by at most one patient.
