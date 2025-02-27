## Scene 
A piece of forniture is a rectangular parallelepiped, whose width (along the X-axis) is $\mathbf{l}=1$.
The other dimensions, namely the depth $\mathbf{m}$ along the $y$-axis and the height $\mathbf{h}$ along the $Z$-axis are unknown. 
In addition, a horizontal circumference (i.e., parallel to the $xy$ plane) is visible. 
Furthermore, an unknown horizontal planar curve is also visible, placed at midheight $\dfrac{\mathbf{h}}{2}$.

![Scene](https://github.com/Chri060/iacv-homework-rossi/blob/main/image/scene.jpg)

## Image
A single image is taken of the above rectangular parallelepiped by an uncalibrated, zero-skew, camera (its calibration matrix $\mathbf{K}$ depends on four unknown parameters, namely $f_x$ and $f_y$ and the two pixel coordinates $U_o$ and $V_o$ of the principal point). 
A set of lines parallel to $x$-axis are visbile, and their images $\mathbf{l}_1$, $\mathbf{l}_2$ and $\mathbf{l}_3$ are extracted; a set of lines parallel to the $y$-axis are visible and their images $\mathbf{m}_1$, $\mathbf{m}_2$, $\mathbf{m}_3$, $\mathbf{m}_4$, $\mathbf{m}_5$, and $\mathbf{m}_6$ are extracted; a set of vertical lines (i.e., parallel to the $Z$-axis) are also visible and their images $\mathbf{h}_1$, $\mathbf{h}_2$, $\mathbf{h}_3$ and $\mathbf{h}_4$ are extracted. 
In addition, both the image $\mathbf{C}$ of the circumference and the image $\mathbf{S}$ of the unknown horizontal curve are also extracted. 
