# Sinan 快速启动

## 🚀 快速启动

### 国内用户（阿里云镜像）
```bash
# 1. 克隆项目
git clone https://github.com/peixyj/sinan-quick-start.git
cd sinan-quick-start

# 2. 配置环境变量
cp .env.example .env
# 编辑 .env 文件，填入你的配置

# 3. 启动服务
docker-compose -f docker-compose-cn.yaml up -d
```

### 国外用户（GitHub 镜像）
```bash
# 1. 克隆项目
git clone https://github.com/peixyj/sinan-quick-start.git
cd sinan-quick-start

# 2. 配置环境变量
cp .env.example .env
# 编辑 .env 文件，填入你的配置

# 3. 启动服务
docker-compose up -d
```

基于 Docker Compose 的 Sinan 项目快速启动方案，包含完整的前后端服务和数据库环境。

![Package Status](https://github.com/PeixyJ/sinan-quick-start/workflows/Package%20and%20Upload%20Artifacts/badge.svg)

## 📋 环境变量配置

创建 `.env` 文件并配置以下变量：

### 必需配置
```env
# GitHub OAuth (必需)
GITHUB_CLIENT_ID=your_github_client_id
GITHUB_CLIENT_SECRET=your_github_client_secret
GITHUB_REDIRECT_URI=http://localhost/github-callback

# Sinan 基础配置
SINAN_BASE_URL=https://your-domain.com
PASSKEY_ID=https://your-domain.com
PASSKEY_ORIGIN=https://your-domain.com
```

### AI 功能配置
```env
# OpenAI 配置 (可选)
OPENAI_API_KEY=your_openai_api_key
OPENAI_BASE_URL=https://api.openai.com
OPENAI_MODEL=gpt-4o-mini
```

### 邮件功能配置
```env
# SMTP 配置 (可选)
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=your_app_password
MAIL_SSL_ENABLE=true
MAIL_SSL_REQUIRED=true
MAIL_STARTTLS_ENABLE=false
MAIL_STARTTLS_REQUIRED=false
```

### 文件上传配置
```env
# 上传路径配置
UPLOAD_BASE_PATH=./upload
UPLOAD_ICON_PATH=icons
UPLOAD_AVATAR_PATH=avatars
UPLOAD_URL_PREFIX=/api/user
FAVICON_CACHE_DIR=upload/icons
```

## 🏗️ 服务架构

本项目包含以下服务：

- **sinan-server**: 后端API服务 (端口 8080)
- **sinan-website**: 前端Web应用 (端口 80)
- **MySQL 8.0**: 主数据库 (端口 3306)
- **Redis 7**: 缓存和会话存储 (端口 6379)

## 📁 目录结构

```
sinan-quick-start/
├── docker-compose.yaml          # 国外用户使用
├── docker-compose-cn.yaml       # 国内用户使用
├── application.yaml             # Spring Boot 配置
├── nginx.conf                   # Nginx 配置
├── sinan_dev.sql               # 数据库初始化脚本
├── .env.example                # 环境变量模板
├── logs/                       # 日志目录
└── upload/                     # 文件上传目录
```

## 🔧 访问地址

- **前端网站**: http://localhost
- **后端 API**: http://localhost/api
- **健康检查**: http://localhost/api/actuator/health

## 镜像选择

本项目提供两个版本的Docker Compose配置：

### 1. 国际版本 (docker-compose.yaml)
适用于海外用户或网络环境良好的用户：
- `ghcr.io/peixyj/sinan-server:latest`
- `ghcr.io/peixyj/sinan-website:latest`
- `redis:7-alpine`
- `mysql:8.0`

### 2. 中国版本 (docker-compose-cn.yaml)
适用于中国大陆用户，使用阿里云镜像仓库：
- `registry.cn-hangzhou.aliyuncs.com/yixing-tech/sinan-server:latest`
- `registry.cn-hangzhou.aliyuncs.com/yixing-tech/sinan-website:latest`
- `registry.cn-hangzhou.aliyuncs.com/yixing-tech/redis:8.2.1`
- `registry.cn-hangzhou.aliyuncs.com/yixing-tech/mysql:8.4.6`

**建议中国大陆用户使用 `docker-compose-cn.yaml` 以获得更快的下载速度。**

## 必需配置文件

在启动服务之前，您需要在项目根目录创建以下配置文件：

### 1. application.yaml
Spring Boot 应用配置文件，用于配置后端服务。示例配置：

```yaml
spring:
  application:
    name: sinan-server
  datasource:
    url: jdbc:mysql://mysql:3306/sinan?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: sinan
    password: sinan123
    driver-class-name: com.mysql.cj.jdbc.Driver
  
  redis:
    host: redis
    port: 6379
    database: 0
    
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: false
    database-platform: org.hibernate.dialect.MySQL8Dialect

logging:
  level:
    com.sinan: INFO
  file:
    name: /app/logs/sinan-server.log
```

### 2. nginx.conf
Nginx 配置文件，用于前端服务的反向代理配置。示例配置：

```nginx
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    
    sendfile        on;
    keepalive_timeout  65;
    
    upstream backend {
        server sinan-server:8080;
    }
    
    server {
        listen       80;
        server_name  localhost;
        
        # 前端静态资源
        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
            try_files $uri $uri/ /index.html;
        }
        
        # API 代理
        location /api/ {
            proxy_pass http://backend/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
        
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
    }
}
```

## 服务配置

### MySQL 数据库
- **版本**: MySQL 8.0
- **端口**: 3306
- **数据库名**: sinan
- **用户名**: sinan
- **密码**: sinan123
- **Root密码**: root123
- **初始化脚本**: `sinan_dev.sql`

### Redis 缓存
- **版本**: Redis 7 Alpine
- **端口**: 6379
- **持久化**: AOF模式

### 应用服务
- **后端API**: 端口 8080
- **前端Web**: 端口 80

## 📊 数据库配置

默认数据库配置：
- **数据库名**: sinan
- **用户名**: sinan
- **密码**: sinan123
- **Root 密码**: root123

## 🔍 故障排查

### 查看服务状态
```bash
docker-compose ps
```

### 查看日志
```bash
# 查看所有服务日志
docker-compose logs

# 查看特定服务日志
docker-compose logs sinan-server
```

### 重启服务
```bash
docker-compose restart
```

### 停止服务
```bash
docker-compose down
```

## 🛠️ 开发模式

如需开发调试，可以单独启动后端：
```bash
# 启动数据库和缓存
docker-compose up -d mysql redis

# 本地运行后端
./mvnw spring-boot:run

# 启动前端
docker-compose up sinan-website
```

## 📝 配置说明

### application.yaml 主要配置项：

- **数据库连接**: 支持 MySQL 8.0
- **缓存**: Redis 连接池配置
- **AI 集成**: OpenAI API 支持
- **邮件**: SMTP 邮件发送
- **文件上传**: 支持图标、头像上传
- **认证**: Sa-Token JWT 认证
- **数据库迁移**: Flyway 自动迁移

### Docker Compose 特性：

- **健康检查**: 自动监控服务状态
- **数据持久化**: 数据库和 Redis 数据持久化
- **自动重启**: 服务异常时自动重启
- **日志管理**: 集中化日志收集

### 健康检查

项目包含健康检查机制：
- MySQL: 每30秒检查数据库连接状态
- 后端服务: 每30秒检查 `/api/actuator/health` 端点
- 前端服务: 每30秒检查主页访问状态

## 配置说明

### 环境变量

后端服务主要环境变量：
- `SPRING_PROFILES_ACTIVE`: Spring 配置文件
- `DB_HOST`: 数据库主机（默认: mysql）
- `DB_PORT`: 数据库端口（默认: 3306）
- `DB_NAME`: 数据库名（默认: sinan）
- `DB_USERNAME`: 数据库用户名（默认: sinan）
- `DB_PASSWORD`: 数据库密码（默认: sinan123）
- `REDIS_HOST`: Redis主机（默认: redis）
- `REDIS_PORT`: Redis端口（默认: 6379）

### GitHub OAuth配置

如需使用GitHub OAuth功能，请配置以下环境变量：
- `GITHUB_CLIENT_ID`: GitHub应用客户端ID
- `GITHUB_CLIENT_SECRET`: GitHub应用客户端密钥
- `GITHUB_REDIRECT_URI`: OAuth回调地址

### Sinan相关配置

如需使用Sinan相关功能，请配置以下环境变量：
- `SINAN_BASE_URL`: Sinan应用的基础URL（如 `sinan.host`）
- `UPLOAD_BASE_PATH`: 文件上传的基础路径（如 `./upload`）
- `UPLOAD_ICON_PATH`: 图标文件存储路径（如 `icons`）
- `UPLOAD_URL_PREFIX`: 文件上传的URL前缀（如 `/api/bookmark`）

### Passkey认证配置
如需使用Passkey认证功能，请配置以下环境变量：
- `PASSKEY_ID`: Passkey认证的ID（如 `sinan.host`）
- `PASSKEY_NAME`: Passkey认证的名称（如 `sinan`）
- `PASSKEY_ORIGIN`: Passkey认证的来源（如 `https://sinan.host`）

## 数据持久化

项目使用Docker卷进行数据持久化：
- `mysql_data`: MySQL数据文件
- `redis_data`: Redis数据文件
- `./logs`: 应用日志文件

## 配置文件管理

项目使用本地配置文件挂载方式：
- `./application.yaml`: Spring Boot 应用配置，挂载到容器的 `/resources/application.yaml`
- `./nginx.conf`: Nginx 配置文件，挂载到容器的 `/etc/nginx/nginx.conf`
- `./sinan_dev.sql`: MySQL 初始化脚本，在容器启动时自动执行

这种方式的优势：
- ✅ 配置文件版本控制
- ✅ 易于修改和维护
- ✅ 项目自包含，无需外部依赖
- ✅ 部署时配置统一管理

## 常用命令

### 中国大陆用户 (阿里云镜像)

```bash
# 启动所有服务
docker-compose -f docker-compose-cn.yaml up -d

# 查看服务状态
docker-compose -f docker-compose-cn.yaml ps

# 查看服务日志
docker-compose -f docker-compose-cn.yaml logs -f [service-name]

# 停止所有服务
docker-compose -f docker-compose-cn.yaml down

# 停止服务并删除数据卷
docker-compose -f docker-compose-cn.yaml down -v

# 重新构建并启动
docker-compose -f docker-compose-cn.yaml up -d --build

# 进入MySQL容器
docker-compose -f docker-compose-cn.yaml exec mysql mysql -u sinan -p

# 进入Redis容器
docker-compose -f docker-compose-cn.yaml exec redis redis-cli
```

### 海外用户 (GitHub镜像)

```bash
# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看服务日志
docker-compose logs -f [service-name]

# 停止所有服务
docker-compose down

# 停止服务并删除数据卷
docker-compose down -v

# 重新构建并启动
docker-compose up -d --build

# 进入MySQL容器
docker-compose exec mysql mysql -u sinan -p

# 进入Redis容器
docker-compose exec redis redis-cli
```

## 故障排除

### 服务启动失败
1. 检查端口是否被占用
2. 确保Docker有足够权限
3. 查看服务日志：`docker-compose logs [service-name]`
4. 确认必需的配置文件是否存在且格式正确

### 配置文件问题
1. 检查 `application.yaml` 文件格式是否正确
2. 验证 `nginx.conf` 配置语法
3. 确认文件路径和权限设置

### 数据库连接问题
1. 确保MySQL服务已完全启动（查看健康检查状态）
2. 检查数据库凭据配置
3. 验证初始化脚本是否正确执行

### 前端无法访问后端
1. 确认后端服务健康状态
2. 检查网络配置
3. 验证API基础URL配置

## 开发模式

如需在开发模式下运行：

1. 停止相应的容器
2. 在本地启动开发服务
3. 修改环境变量指向本地数据库和Redis

## 自动化构建与发布

本项目使用 GitHub Actions 进行自动化打包和发布。

### 构建触发条件
- **Push** 到 `main` 或 `develop` 分支
- **标签** 推送 (v*)
- **Pull Request** 到 `main` 分支
- **手动触发** (workflow_dispatch)

### 制品下载

#### 开发版本
每次代码推送都会自动构建并上传制品，您可以：
1. 访问 [Actions 页面](https://github.com/PeixyJ/sinan-quick-start/actions)
2. 选择最新的构建记录
3. 下载 `sinan-quick-start-package-xxx` 制品（自动打包为ZIP）

#### 正式版本
创建标签时会自动创建 Release：
1. 访问 [Releases 页面](https://github.com/PeixyJ/sinan-quick-start/releases)
2. 下载最新版本的 ZIP 包
3. 验证文件完整性（使用 checksums.txt）

### 包内容
自动构建的包包含：
- `docker-compose.yaml` - Docker Compose 配置 (GitHub镜像)
- `docker-compose-cn.yaml` - Docker Compose 配置 (阿里云镜像)
- `application.yaml` - Spring Boot 配置
- `nginx.conf` - Nginx 配置
- `sinan_dev.sql` - 数据库初始化脚本
- `README.md` - 完整文档
- `package-info.txt` - 构建信息

### 创建正式版本
```bash
# 创建标签并推送
git tag v1.0.0
git push origin v1.0.0

# 这将自动触发构建并创建 Release
```

## 版本信息

- Docker Compose: 3.8
- MySQL: 8.0
- Redis: 7-alpine
- 后端服务: latest
- 前端服务: latest

## 许可证

请参考项目许可证文件。
