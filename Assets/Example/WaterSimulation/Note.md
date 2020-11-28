## Gerstner Wave
波型越接近波峰函数的变化率越大比正弦波表现波峰更加锋利，也更加符合海浪的表现   
公式：
$$
P(x,y,t) =
\begin{cases}
x+\sum(Q_i A_i\times D_{i} \cdot x \times\cos(\omega_iD_i\cdot(x,y)+\varphi_it))\\
\\
y+\sum(Q_iA_i\times D_i\cdot z\times\cos(\omega_i\cdot (x,y)+\varphi_it))\\
\\
\sum(A_i\sin(\omega_iD_i\cdot(x,y)+t\varphi_i))
\end{cases}
$$
Q 为波形中的尖锐程度,当Q为0的时候就和正弦波一样
$$
\omega = \sqrt{g\times \frac{2\pi}{L}}
$$
法线
$$
N=\begin{cases}
-\sum{(D_i \ldotp x\times \omega_i \times A_i\times\cos(\omega_i\times D_i\cdot (x,y)+t\varphi)}\\
\\
-\sum{(D_i \ldotp y\times \omega_i \times A_i\times\cos(\omega_i\times D_i\cdot (x,y)+t\varphi)}\\
\\
1-\sum{(Q_i \times \omega_i \times A_i\times\sin(\omega_i\times D_i\cdot (x,y)+t\varphi)}
\end{cases}
$$
切线
$$
T=\begin{cases}
-\sum{Q_i\times D_i\ldotp x\times D_i\ldotp y\times\omega_1\times A\times\sin(\omega_i\times D_i\cdot (x,y)+\varphi_it) }\\
\\
1-\sum(Q_i\times {D_i\ldotp{y}}^2\times W_i\times A_i\times \sin(\omega_i\times D_i\cdot (x,y)+\varphi_it))\\
\\
\sum(D_i\ldotp y\times W_i\times A_i\times\cos(\omega_i\times D_i\cdot (x,y)+\varphi_i t)
\end{cases}
$$