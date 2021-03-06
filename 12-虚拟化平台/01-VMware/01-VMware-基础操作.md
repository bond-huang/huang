# VMware-基础操作
个人版用的比较多，企业版用的比较少，一些简单操作记录下来避免忘记。
## 存储迁移
&#8195;&#8195;VMware平台上一台物理机上有多个虚拟机，一块分配过来的存储盘也经常给多个虚拟机使用。在替换后端存储的时候，可以通过VMware上的虚拟机迁移功能去迁移虚拟机的存储盘（只改变存储盘，不改变虚拟机所在的物理机），优点就是在线迁移，单个虚拟机也很快；缺点就是如果比较多虚拟机太慢了，并发量也需要控制，避免I/O过高产生影响。

具体迁移步骤如下：
- 将新存储跟集群物理机划分好zone，将新磁盘分配给集群，
- 登录VMware的vSphere client，选择对应的集群
- 右键，在`Storage`选择中选择`Rescan Storage`
- 在弹出的“重新扫描存储”对话框中，选择“扫描新的存储设备”，不选中“扫描新的VMFS卷”
- 弹出对话框“新建数据存储”:
    - 类型：选择`VMFS`
    - 名称和设备选择：自定义数据存储名称（例如叫VOLnew）；选择集群中任意一个主机，然后可以看到扫描到的磁盘，选择需要添加的磁盘
    - VMFS版本：有些版本会有此步骤，选择对应的即可
    - 分区配置：默认使用过所有可用分区
    - 即将完成：检查配置，没问题就点击`FINISH`
- 在左侧集群菜单里面可用看到新分配的存储盘：VOLnew
- 点击选择就旧存储盘，例如叫：VOLold，查看存储盘下所有Virtual Machines
- 选中需要迁移得虚拟机，右键，选择`Migrate`(会提示兼容性）：
    - 选择迁移类型：仅更改存储（根据需求选择）
    - 选择存储：磁盘格式选择精简置配；虚拟机存储策略选择保留现有得虚拟机存储策略；勾上禁用此虚拟机得存储DRS;最后选中目标磁盘VOLnew
    - 即将完成：检查配置，没问题就点击`FINISH`
- 然后可以看到精度条，迁移完成后进行检查

注意事项：
- 可以一次选择多个虚拟机进行迁移，但是批量迁移的虚拟机都必须处于同一电源状态
- 批量迁移注意I/O量，一次性过多可能会影响到其它虚拟机正常运行，存储端的性能同样需要关注
- 有些虚拟机可能迁移不了，重启下物理机可能就解决了
- 有些集群开启了自动均衡功能，就是他会自动迁移虚拟机到比较闲的磁盘，可以更改此策略或者对于不打算用的旧盘标记成维护模式
- 确认不要的盘建议核实清楚没有了虚拟机在上面后再删除，最好先标记成维护模式（很多卷名称可能差不多，标记成维护模式的图标会发生改变，区别正在使用磁盘比较明显），过后再删除

## 待补充
