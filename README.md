RefMe - Patient Referral Scheduler

Kaui Lebarbenchon, Daniel Yao

30 July 2024

The scheduling problem for $n$ patients and a time horizon of $h$ times may be formulated as follows. Let $h \in H$ enumerate the time positions. Let $n \in N$ enumerate the patients. Let $h$ enumerate the times a patient may be seen. Let $x_{nh}$ be the indicator that is $1$ if patient $n$ is seen at time $h$ and is $0$ otherwise. Let $p_{nh}$ be the penalty for not seeing patient $n$ on or before time $h$. (For all $h$ on and after patient n is seen, $p_{nh} = 0$. We minimize 

$$\sum_{n \in N}\sum_{h \in H}p_{nh}(1 - x_{nh})$$

subject to the constraints

$$\sum_{h \in H}x_{nh} = 1$$

for all $n \in N$ and 

$$\sum_{n \in N}x_{nh} \leq 1$$

for all $h \in H$ and 

$$x_{nh} \in \\{ 0, 1 \\}$$

for all $n \in N, h \in H$ and 

$$n, h \in \mathbb{N}$$

for all $n \in N, h \in H$. The first two of these constraints specify that (1) a patient must be seen exactly once in the time horizon and (2) each time may be occupied by at most one patient. The objective function and constraints specify a integer linear programming problem.

Our project addresses the case that patients are received in a data stream. That is, when scheduling patient $n_{0}$, we cannot change the positions of any patients $m < n_{0}$ and we cannot know the positions of any patients $n_{i} > n_{0}$. 

For a patient $n_{0}$, the problem is formulated as follows. Let $h \in H$ enumerate the time positions. Let $m \in M$ enumerate the patients that have already been scheduled, and let patient $m$ occupy time $h_{m} \in H$. Let $N \sim \text{Poisson}(\lambda)$ be the number of patients yet to be scheduled. Let $n_{0}, n_{1}, ..., n_{N} \in N$ enumerate the patients that are yet to be scheduled. Let $x_{nh}$ be the indicator that is $1$ if patient $n$ is seen at time $h$ and is $0$ otherwise. Similarly, let $x_{mh}$ be the indicator that is $1$ if patient $m$ is seen at time $h$ and is $0$ otherwise. Let $p_{nh}$ be the penalty for not seeing patient $n$ on or before time $h$. (For all $h$ on and after patient n is seen, $p_{nh} = 0$. We minimize 

$$\mathbb{E}\left[ \sum_{n \in N}\sum_{h \in H}p_{nh}(1 - x_{nh}) \right]$$

subject to the constraints

$$\sum_{h \in H}x_{ph} = 1$$

for all $p \in M \cup N$.
