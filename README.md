# Glim

Gua's film filter camera - A vintage filter camera app built with Flutter.

## Project Structure

```
glim/
├── android/                     # Android 平台配置
├── ios/                         # iOS 平台配置
├── assets/                      # 静态资源
│   ├── filters/                 # 滤镜相关资源
│   └── icons/                   # 图标资源
├── lib/                         # Dart 源代码
│   ├── main.dart                # 应用入口
│   ├── core/                    # 核心模块
│   ├── features/                # 功能模块
│   └── shared/                  # 共享组件
├── test/                        # 测试代码
└── pubspec.yaml                 # 依赖配置
```

## Lib Directory Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── features/
│   ├── camera/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   └── providers/
│   ├── filters/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── presets/
│   │   ├── presentation/
│   │   │   └── widgets/
│   │   └── providers/
│   └── gallery/
│       ├── presentation/
│       │   ├── screens/
│       │   └── widgets/
│       └── providers/
└── shared/
    └── widgets/
```

## Module Responsibilities

### `core/` - 核心模块
应用级别的基础设施代码，被多个 feature 共享使用。

| 目录 | 职能 |
|------|------|
| `constants/` | 全局常量定义，包括颜色值、尺寸规范、字符串常量、API 配置等 |
| `theme/` | 应用主题配置，包括 ThemeData、颜色方案、文字样式、组件主题等 |
| `utils/` | 通用工具类，包括日期格式化、文件操作、图片处理、权限请求等辅助函数 |

### `features/` - 功能模块
按功能划分的业务模块，每个模块相对独立，遵循 Feature-based 架构。

#### `features/camera/` - 相机模块
负责相机预览、拍照、实时滤镜预览等核心拍摄功能。

| 目录 | 职能 |
|------|------|
| `presentation/screens/` | 相机页面，包括主拍摄界面、拍摄设置页面等 |
| `presentation/widgets/` | 相机相关组件，如快门按钮、闪光灯切换、前后摄像头切换、缩放控制等 |
| `providers/` | 相机状态管理，包括 CameraController 生命周期、拍摄状态、相机参数等 |

#### `features/filters/` - 滤镜模块
负责滤镜效果的定义、管理和应用。

| 目录 | 职能 |
|------|------|
| `data/models/` | 滤镜数据模型，定义滤镜的属性结构（名称、参数、缩略图等） |
| `data/presets/` | 预设滤镜集合，包含各种复古滤镜的具体参数配置（胶片、褪色、暖色调等） |
| `presentation/widgets/` | 滤镜 UI 组件，如滤镜选择器、滤镜预览卡片、滤镜强度调节滑块等 |
| `providers/` | 滤镜状态管理，包括当前选中滤镜、滤镜强度、滤镜列表等状态 |

#### `features/gallery/` - 相册模块
负责已拍摄照片的展示、预览和管理。

| 目录 | 职能 |
|------|------|
| `presentation/screens/` | 相册页面，包括照片列表页、照片详情预览页、照片编辑页等 |
| `presentation/widgets/` | 相册相关组件，如照片网格、照片卡片、图片查看器、分享按钮等 |
| `providers/` | 相册状态管理，包括照片列表、选中状态、加载状态等 |

### `shared/` - 共享模块
跨功能模块复用的 UI 组件。

| 目录 | 职能 |
|------|------|
| `widgets/` | 通用 UI 组件，如自定义按钮、加载指示器、空状态提示、错误提示等可复用组件 |

## Dependencies

| 依赖 | 版本 | 用途 |
|------|------|------|
| `camera` | ^0.11.1 | 相机预览和拍照 |
| `image` | ^4.5.4 | 图像处理 |
| `colorfilter_generator` | ^0.0.8 | 颜色滤镜生成 |
| `path_provider` | ^2.1.5 | 文件路径获取 |
| `image_gallery_saver_plus` | ^4.0.1 | 保存图片到相册 |
| `permission_handler` | ^11.4.0 | 运行时权限管理 |
| `flutter_riverpod` | ^2.6.1 | 状态管理 |
| `riverpod_annotation` | ^2.6.1 | Riverpod 注解 |
| `uuid` | ^4.5.1 | 唯一 ID 生成 |

## Architecture Pattern

本项目采用 **Feature-based Architecture** 结合 **Riverpod** 状态管理：

- **Feature-based**: 按功能模块划分代码，每个功能模块包含自己的 UI 层和状态管理层
- **Presentation Layer**: 负责 UI 渲染，包括 screens（页面）和 widgets（组件）
- **Provider Layer**: 使用 Riverpod 管理状态，处理业务逻辑
- **Data Layer**: 数据模型和预设配置（仅 filters 模块需要）

## Getting Started

```bash
# 安装依赖
flutter pub get

# 运行应用
flutter run

# 生成 Riverpod 代码（如使用 code generation）
dart run build_runner build
```

## Platform Permissions

### iOS
- Camera (`NSCameraUsageDescription`)
- Photo Library (`NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription`)
- Microphone (`NSMicrophoneUsageDescription`)

### Android
- `CAMERA`
- `READ_EXTERNAL_STORAGE` / `READ_MEDIA_IMAGES`
- `WRITE_EXTERNAL_STORAGE`
- `RECORD_AUDIO`
