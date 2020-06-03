## zj-microservice-web-ide 插件使用手册

注意事项：

1. 可同时管理多个微服务项目，但是只有在 idea 中打开的项目才可以访问
2. idea 启动时，本插件会监听本地的 32000 端口，所以请保证该端口没有被其他程序使用

### 打开 web-ide 并进入项目的首页

访问 `http://ip:32000?url={projectName}` 可进入 web-ide 首页，其中 {projectName} 为项目文件夹名（非项目gradle rootProjectName）

或者使用 idea 上方菜单中的 `Tools->在 WEB-IDE 中打开项目` 功能，可自动打开浏览器并进入首页，如果该功能打开的浏览器不是你想要的，可以在 `Settings->Tools->Web Browsers` 中进行设置

### 功能目录

- [安装](./setup.md)
- [资源管理器](./explorer.md)
- [流程编辑器](./workflow-editor.md)