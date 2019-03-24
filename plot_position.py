from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 unused import
import matplotlib.pyplot as pyplot

import process_signals


l_acc, l_gyr, r_acc, r_gyr = get_signals_as_matrices("Shot-Left-1.csv")

l_acc_x, l_acc_y, l_acc_z = split_signal(l_acc)


fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

ax.scatter(l_acc_x, l_acc_y, l_acc_z)

ax.set_xlabel('X Label')
ax.set_ylabel('Y Label')
ax.set_zlabel('Z Label')

plt.show()