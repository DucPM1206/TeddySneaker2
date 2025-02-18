USE [master]
GO
/****** Object:  Database [TeddySneaker2]    Script Date: 16/01/2025 10:48:26 SA ******/
CREATE DATABASE [TeddySneaker2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TeddySneaker2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TeddySneaker2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TeddySneaker2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TeddySneaker2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [TeddySneaker2] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TeddySneaker2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TeddySneaker2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TeddySneaker2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TeddySneaker2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TeddySneaker2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TeddySneaker2] SET ARITHABORT OFF 
GO
ALTER DATABASE [TeddySneaker2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TeddySneaker2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TeddySneaker2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TeddySneaker2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TeddySneaker2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TeddySneaker2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TeddySneaker2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TeddySneaker2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TeddySneaker2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TeddySneaker2] SET  ENABLE_BROKER 
GO
ALTER DATABASE [TeddySneaker2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TeddySneaker2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TeddySneaker2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TeddySneaker2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TeddySneaker2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TeddySneaker2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TeddySneaker2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TeddySneaker2] SET RECOVERY FULL 
GO
ALTER DATABASE [TeddySneaker2] SET  MULTI_USER 
GO
ALTER DATABASE [TeddySneaker2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TeddySneaker2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TeddySneaker2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TeddySneaker2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TeddySneaker2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TeddySneaker2] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'TeddySneaker2', N'ON'
GO
ALTER DATABASE [TeddySneaker2] SET QUERY_STORE = ON
GO
ALTER DATABASE [TeddySneaker2] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [TeddySneaker2]
GO
/****** Object:  Table [dbo].[brand]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[brand](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[thumbnail] [varchar](255) NULL,
	[status] [bit] NULL,
	[created_at] [datetime2](6) NULL,
	[modified_at] [datetime2](6) NULL,
 CONSTRAINT [PK__brand__3213E83FACBF2759] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[category]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[category](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](300) NOT NULL,
	[slug] [varchar](255) NOT NULL,
	[status] [bit] NULL,
	[created_at] [datetime2](6) NULL,
	[modified_at] [datetime2](6) NULL,
 CONSTRAINT [PK__category__3213E83F57F49A1E] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[comment]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[comment](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[content] [text] NULL,
	[user_id] [bigint] NULL,
	[product_id] [varchar](255) NULL,
	[created_at] [datetime2](6) NULL,
	[status] [int] NULL,
	[post_id] [bigint] NULL,
 CONSTRAINT [PK__comment__3213E83F2DAB4992] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[images]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[images](
	[id] [varchar](255) NOT NULL,
	[name] [nvarchar](255) NULL,
	[type] [varchar](255) NULL,
	[size] [bigint] NULL,
	[link] [varchar](255) NULL,
	[created_at] [datetime2](6) NULL,
	[created_by] [bigint] NULL,
 CONSTRAINT [PK__images__3213E83F08BB9DA4] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_details]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_details](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[product_price] [bigint] NOT NULL,
	[quantity] [int] NOT NULL,
	[size] [int] NOT NULL,
	[subtotal] [bigint] NOT NULL,
	[order_id] [bigint] NOT NULL,
	[product_id] [varchar](255) NOT NULL,
	[coupon_code] [varchar](255) NULL,
	[discount] [bigint] NULL,
 CONSTRAINT [PK__order_de__3213E83FE9CE3A55] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[receiver_name] [nvarchar](255) NULL,
	[receiver_phone] [varchar](255) NULL,
	[receiver_address] [nvarchar](255) NULL,
	[note] [nvarchar](255) NULL,
	[price] [bigint] NULL,
	[total_price] [bigint] NULL,
	[size] [int] NULL,
	[quantity] [int] NULL,
	[buyer] [bigint] NULL,
	[product_id] [varchar](255) NULL,
	[status] [int] NULL,
	[created_at] [datetime2](6) NULL,
	[modified_at] [datetime2](6) NULL,
	[created_by] [bigint] NULL,
	[modified_by] [bigint] NULL,
	[promotion] [nvarchar](max) NULL,
	[buyer_id] [bigint] NULL,
	[product] [nvarchar](max) NULL,
	[coupon_code] [varchar](255) NULL,
	[discount] [bigint] NULL,
 CONSTRAINT [PK__orders__3213E83FF067F9B5] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[post]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[post](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](300) NULL,
	[content] [text] NULL,
	[description] [text] NULL,
	[slug] [varchar](600) NULL,
	[thumbnail] [varchar](255) NULL,
	[created_at] [datetime2](6) NULL,
	[modified_at] [datetime2](6) NULL,
	[published_at] [datetime2](6) NULL,
	[status] [int] NULL,
	[created_by] [bigint] NULL,
	[modified_by] [bigint] NULL,
 CONSTRAINT [PK__post__3213E83FE15D6E13] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product](
	[id] [varchar](255) NOT NULL,
	[product_code] [varchar](255) NULL,
	[name] [nvarchar](300) NOT NULL,
	[description] [nvarchar](max) NULL,
	[price] [bigint] NULL,
	[sale_price] [bigint] NULL,
	[slug] [varchar](255) NOT NULL,
	[images] [nvarchar](max) NULL,
	[image_feedback] [nvarchar](max) NULL,
	[product_view] [int] NULL,
	[total_sold] [bigint] NULL,
	[status] [int] NULL,
	[created_at] [datetime2](6) NULL,
	[modified_at] [datetime2](6) NULL,
	[brand_id] [bigint] NULL,
 CONSTRAINT [PK__product__3213E83F2065A03D] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product_category]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_category](
	[product_id] [varchar](255) NOT NULL,
	[category_id] [bigint] NOT NULL,
 CONSTRAINT [PK__product___1A56936EF6C699BF] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC,
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[product_size]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_size](
	[product_id] [varchar](255) NOT NULL,
	[size] [int] NOT NULL,
	[quantity] [int] NULL,
 CONSTRAINT [PK__product___85FA4A1BF9792C69] PRIMARY KEY CLUSTERED 
(
	[product_id] ASC,
	[size] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[promotion]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[promotion](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](300) NOT NULL,
	[coupon_code] [varchar](255) NULL,
	[discount_type] [int] NULL,
	[discount_value] [bigint] NULL,
	[maximum_discount_value] [bigint] NULL,
	[is_active] [bit] NULL,
	[is_public] [bit] NULL,
	[created_at] [datetime2](6) NULL,
	[expired_at] [datetime2](6) NULL,
 CONSTRAINT [PK__promotio__3213E83F302094D9] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[statistic]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[statistic](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[created_at] [datetime2](6) NULL,
	[profit] [bigint] NULL,
	[quantity] [int] NULL,
	[sales] [bigint] NULL,
	[order_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_used_promotion]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_used_promotion](
	[user_id] [bigint] NOT NULL,
	[promotion_id] [bigint] NOT NULL,
	[used_at] [datetime] NULL,
 CONSTRAINT [PK__user_use__1B75A25958E7303F] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[promotion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 16/01/2025 10:48:26 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[full_name] [nvarchar](255) NULL,
	[email] [varchar](200) NOT NULL,
	[password] [varchar](255) NOT NULL,
	[phone] [varchar](255) NULL,
	[address] [nvarchar](255) NULL,
	[avatar] [varchar](255) NULL,
	[roles] [nvarchar](max) NOT NULL,
	[status] [bit] NULL,
	[created_at] [datetime2](6) NULL,
	[modified_at] [datetime2](6) NULL,
 CONSTRAINT [PK__users__3213E83F617FE753] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[brand] ON 

INSERT [dbo].[brand] ([id], [name], [description], [thumbnail], [status], [created_at], [modified_at]) VALUES (1, N'Nike', NULL, N'/media/static/4514bc38-bae2-4910-a31d-94fba1ec9dd3.png', 1, CAST(N'2025-01-15T10:34:35.1910000' AS DateTime2), NULL)
INSERT [dbo].[brand] ([id], [name], [description], [thumbnail], [status], [created_at], [modified_at]) VALUES (2, N'Vans', NULL, N'/media/static/fe785045-54d0-4896-8d87-76b289096ad6.png', 1, CAST(N'2025-01-15T10:34:52.6550000' AS DateTime2), NULL)
INSERT [dbo].[brand] ([id], [name], [description], [thumbnail], [status], [created_at], [modified_at]) VALUES (3, N'Li-Ning', NULL, N'/media/static/41b7bda5-cac1-4f7d-9de0-5f027fea0bf9.jpg', 1, CAST(N'2025-01-15T10:36:44.7730000' AS DateTime2), NULL)
INSERT [dbo].[brand] ([id], [name], [description], [thumbnail], [status], [created_at], [modified_at]) VALUES (4, N'Converse', NULL, N'/media/static/946a5eb2-6d4f-4121-8ad7-8851317c2f45.png', 1, CAST(N'2025-01-15T10:37:05.9810000' AS DateTime2), NULL)
INSERT [dbo].[brand] ([id], [name], [description], [thumbnail], [status], [created_at], [modified_at]) VALUES (5, N'Adidas', NULL, N'/media/static/3da309cf-470a-4d84-bf78-b91102004db8.png', 1, CAST(N'2025-01-15T10:37:24.7000000' AS DateTime2), NULL)
SET IDENTITY_INSERT [dbo].[brand] OFF
GO
SET IDENTITY_INSERT [dbo].[category] ON 

INSERT [dbo].[category] ([id], [name], [slug], [status], [created_at], [modified_at]) VALUES (1, N'Giày Golf', N'giay-golf', 1, CAST(N'2025-01-15T10:30:04.5370000' AS DateTime2), NULL)
INSERT [dbo].[category] ([id], [name], [slug], [status], [created_at], [modified_at]) VALUES (2, N'Giày bóng rổ', N'giay-bong-ro', 1, CAST(N'2025-01-15T10:30:10.6030000' AS DateTime2), NULL)
INSERT [dbo].[category] ([id], [name], [slug], [status], [created_at], [modified_at]) VALUES (3, N'Giày thời trang', N'giay-thoi-trang', 1, CAST(N'2025-01-15T10:30:23.5090000' AS DateTime2), NULL)
INSERT [dbo].[category] ([id], [name], [slug], [status], [created_at], [modified_at]) VALUES (4, N'Giày chạy bộ', N'giay-chay-bo', 1, CAST(N'2025-01-15T10:30:33.2320000' AS DateTime2), CAST(N'2025-01-15T10:33:45.5660000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[category] OFF
GO
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'0076c26f-de87-4035-ab0f-b871e175e819', N'file', N'jpg', 161749, N'/media/static/0076c26f-de87-4035-ab0f-b871e175e819.jpg', CAST(N'2025-01-15T19:08:59.7400000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'077508e5-b2cf-4636-bef7-a8855f0e5067', N'file', N'jpg', 158089, N'/media/static/077508e5-b2cf-4636-bef7-a8855f0e5067.jpg', CAST(N'2025-01-15T18:55:03.9560000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'0d5dc8d5-781b-4008-aa02-6fbe46941512', N'file', N'jpg', 43154, N'/media/static/0d5dc8d5-781b-4008-aa02-6fbe46941512.jpg', CAST(N'2025-01-15T19:08:33.1990000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'131f0d46-5ef6-4978-9a8b-7bc7e65f8b97', N'file', N'jpg', 105502, N'/media/static/131f0d46-5ef6-4978-9a8b-7bc7e65f8b97.jpg', CAST(N'2025-01-15T18:50:52.6320000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'23a7bce0-f939-40bf-bde6-5dcbf82c001c', N'file', N'jpg', 268324, N'/media/static/23a7bce0-f939-40bf-bde6-5dcbf82c001c.jpg', CAST(N'2025-01-15T10:41:12.4990000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'33f0cd5e-193a-462d-848b-23b4bd138e11', N'file', N'jpg', 49880, N'/media/static/33f0cd5e-193a-462d-848b-23b4bd138e11.jpg', CAST(N'2025-01-15T10:46:47.3380000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'38d75fb7-862e-4645-9007-a70c1a0728d7', N'file', N'jpg', 224628, N'/media/static/38d75fb7-862e-4645-9007-a70c1a0728d7.jpg', CAST(N'2025-01-15T18:54:57.8870000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'3da309cf-470a-4d84-bf78-b91102004db8', N'file', N'png', 3831, N'/media/static/3da309cf-470a-4d84-bf78-b91102004db8.png', CAST(N'2025-01-15T10:37:20.6790000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'3fcc9d62-a174-46ae-8e69-000243263f79', N'file', N'jpg', 117629, N'/media/static/3fcc9d62-a174-46ae-8e69-000243263f79.jpg', CAST(N'2025-01-15T18:55:09.9200000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'41b7bda5-cac1-4f7d-9de0-5f027fea0bf9', N'file', N'jpg', 65008, N'/media/static/41b7bda5-cac1-4f7d-9de0-5f027fea0bf9.jpg', CAST(N'2025-01-15T10:36:40.4470000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'4514bc38-bae2-4910-a31d-94fba1ec9dd3', N'file', N'png', 3685, N'/media/static/4514bc38-bae2-4910-a31d-94fba1ec9dd3.png', CAST(N'2025-01-15T10:34:31.9850000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'451fe03a-4a3d-4827-8b2e-9ea013f6b363', N'file', N'jpg', 150935, N'/media/static/451fe03a-4a3d-4827-8b2e-9ea013f6b363.jpg', CAST(N'2025-01-15T18:55:25.4470000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'499c3c38-cdb9-44b1-8484-a3836225156a', N'file', N'jpg', 124137, N'/media/static/499c3c38-cdb9-44b1-8484-a3836225156a.jpg', CAST(N'2025-01-15T18:51:07.5530000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'5bcabd24-f0e9-425f-b153-55b2441ca4e3', N'file', N'jpg', 160743, N'/media/static/5bcabd24-f0e9-425f-b153-55b2441ca4e3.jpg', CAST(N'2025-01-15T19:09:09.4470000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'6201c370-5a4e-43e2-9e3a-fcfcbd79be31', N'file', N'jpg', 143173, N'/media/static/6201c370-5a4e-43e2-9e3a-fcfcbd79be31.jpg', CAST(N'2025-01-15T10:41:19.8670000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'7c408c3e-5396-4fa3-ad37-82aae6e7b7e8', N'file', N'jpg', 27443, N'/media/static/7c408c3e-5396-4fa3-ad37-82aae6e7b7e8.jpg', CAST(N'2025-01-15T19:13:29.5540000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'85ae782e-9de9-4f78-be1d-a43a0ccd5e8e', N'file', N'jpg', 66538, N'/media/static/85ae782e-9de9-4f78-be1d-a43a0ccd5e8e.jpg', CAST(N'2025-01-15T10:40:47.5420000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'93da4a46-91e9-47de-bc35-0e131d0f4839', N'file', N'jpg', 32726, N'/media/static/93da4a46-91e9-47de-bc35-0e131d0f4839.jpg', CAST(N'2025-01-15T18:50:43.5870000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'946a5eb2-6d4f-4121-8ad7-8851317c2f45', N'file', N'png', 2689, N'/media/static/946a5eb2-6d4f-4121-8ad7-8851317c2f45.png', CAST(N'2025-01-15T10:37:02.0390000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'a11524e9-7a99-419b-bc3f-569facb73173', N'file', N'jpg', 96727, N'/media/static/a11524e9-7a99-419b-bc3f-569facb73173.jpg', CAST(N'2025-01-15T10:46:50.0060000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'ab92376c-59de-4a73-a395-4ba1eae98db5', N'file', N'jpg', 27443, N'/media/static/ab92376c-59de-4a73-a395-4ba1eae98db5.jpg', CAST(N'2025-01-15T10:41:24.6030000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'b487628f-97d8-47d4-8616-0b8c8410045c', N'file', N'jpg', 172072, N'/media/static/b487628f-97d8-47d4-8616-0b8c8410045c.jpg', CAST(N'2025-01-15T19:09:27.6920000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'b86ad894-f6f5-4458-860a-57647f521579', N'file', N'jpg', 129005, N'/media/static/b86ad894-f6f5-4458-860a-57647f521579.jpg', CAST(N'2025-01-15T10:46:52.7520000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'c6cb56a3-86cd-4550-86d4-66e32e6f4c1e', N'file', N'jpg', 100900, N'/media/static/c6cb56a3-86cd-4550-86d4-66e32e6f4c1e.jpg', CAST(N'2025-01-15T10:46:55.5690000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'e1ce6e70-53a8-49b2-ac6d-d47f5bc4da42', N'file', N'jpg', 165080, N'/media/static/e1ce6e70-53a8-49b2-ac6d-d47f5bc4da42.jpg', CAST(N'2025-01-15T18:55:15.5030000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'f1c666b1-195a-4ced-8229-e1d0f81c0583', N'file', N'jpg', 160929, N'/media/static/f1c666b1-195a-4ced-8229-e1d0f81c0583.jpg', CAST(N'2025-01-15T18:50:59.9800000' AS DateTime2), 1)
INSERT [dbo].[images] ([id], [name], [type], [size], [link], [created_at], [created_by]) VALUES (N'fe785045-54d0-4896-8d87-76b289096ad6', N'file', N'png', 4614, N'/media/static/fe785045-54d0-4896-8d87-76b289096ad6.png', CAST(N'2025-01-15T10:34:48.6640000' AS DateTime2), 1)
GO
INSERT [dbo].[product] ([id], [product_code], [name], [description], [price], [sale_price], [slug], [images], [image_feedback], [product_view], [total_sold], [status], [created_at], [modified_at], [brand_id]) VALUES (N'1SWC07', N'APB2018', N'Giày Adidas Pro Bounce 2018 Basketball Shoes ‘White Black’', N'<p 1:1-1:301"="" style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Giày bóng rổ&nbsp;Adidas Pro Bounce 2018 Basketball Shoes ‘White Black’&nbsp;là một đôi giày được thiết kế cho các cầu thủ bóng rổ đang tìm kiếm sự thoải mái,<span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">&nbsp;hiệu suất và phong cách.</span><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">&nbsp;Nó có thiết kế màu trắng và đen thanh lịch với các điểm nhấn màu xám,</span><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">&nbsp;và được làm từ các vật liệu cao cấp cho độ hỗ trợ và độ bền tối đa.</span></p><p 3:1-3:19"="" style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Phần thân trên:</span></p><ul 5:1-5:10"="" style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-left: 0.7em; padding-left: 1.3em; list-style: none; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><li animating"="" 5:1-5:10"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Được làm từ vải lưới thoáng khí với các sợi cước đan ngang dọc để giữ cho đôi chân của bạn mát mẻ và khô ráo trong suốt trận đấu</span></li><li animating"="" 6:1-6:65"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Có cổ áo đệm dày để hỗ trợ mắt cá chân và ngăn ngừa chấn thương</span></li><li animating"="" 7:1-8:0"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Khóa buộc dây để tạo sự vừa vặn chắc chắn</span></li></ul><p 9:1-9:12"="" style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Đế giữa:</span></p><ul 11:1-13:0"="" style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-left: 0.7em; padding-left: 1.3em; list-style: none; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><li animating"="" 11:1-11:102"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Được trang bị đệm Bounce toàn bộ của Adidas cho khả năng hấp thụ sốc và trả lại năng lượng tuyệt vời</span></li><li animating"="" 12:1-13:0"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Có mô hình gai giày đồng tâm giúp bạn duy trì độ bám trên sân</span></li></ul><p 14:1-14:13"="" style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Đế ngoài:</span></p><ul 16:1-17:50"="" style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-left: 0.7em; padding-left: 1.3em; list-style: none; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><li animating"="" 16:1-16:81"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Được làm từ cao su bền với các đường vân tròn đồng tâm để tăng độ bám và độ bền</span></li><li animating"="" 17:1-17:50"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Có điểm trục xoay ở bàn chân trước giúp bạn thực hiện các động tác cắt và chuyển hướng nhanh chóng</span></li></ul><p 19:1-19:213"="" style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Giày bóng rổ Adidas Pro Bounce 2018 ‘White Black’ là một lựa chọn tuyệt vời cho các cầu thủ bóng rổ ở mọi cấp độ đang tìm kiếm một đôi giày thời trang và thoải mái có thể giúp họ nâng tầm trò chơi của mình.</span></p><p 21:1-21:31"="" style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Thông tin chi tiết bổ sung:</span></p><ul 23:1-28:0"="" style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-left: 0.7em; padding-left: 1.3em; list-style: none; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><li animating"="" 23:1-23:22"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Vừa vặn thông thường</span></li><li animating"="" 24:1-24:37"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Phần trên bằng vải lưới và sợi cước</span></li><li animating"="" 25:1-25:21"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Đế giữa bằng Bounce</span></li><li animating"="" 26:1-26:22"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Đế ngoài bằng cao su</span></li></ul><p 29:1-29:12"="" style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Ưu điểm:</span></p><ul 31:1-36:0"="" style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-left: 0.7em; padding-left: 1.3em; list-style: none; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><li animating"="" 31:1-31:35"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Thiết kế thời trang và thanh lịch</span></li><li animating"="" 32:1-32:51"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Chất liệu cao cấp mang lại sự thoải mái và hỗ trợ</span></li><li animating"="" 33:1-33:75"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Đệm Bounce toàn bộ mang lại khả năng đệm và phản hồi năng lượng tuyệt vời</span></li><li animating"="" 34:1-34:39"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Mô hình gai giày đồng tâm tăng độ bám</span></li><li animating"="" 35:1-36:0"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Điểm trục xoay ở bàn chân trước giúp thực hiện các động tác cắt và chuyển hướng nhanh chóng</span></li></ul><p 37:1-37:15"="" style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Nhược điểm:</span></p><ul 39:1-40:48"="" style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-left: 0.7em; padding-left: 1.3em; list-style: none; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><li animating"="" 39:1-39:48"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Có thể hơi nặng so với một số thương hiệu khác</span></li><li animating"="" 40:1-40:48"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;"><span animating"="" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Không phù hợp cho các cầu thủ có bàn chân rộng</span></li></ul>', 1000000, 1400000, N'giay-adidas-pro-bounce-2018-basketball-shoes-white-black', N'["/media/static/ab92376c-59de-4a73-a395-4ba1eae98db5.jpg","/media/static/6201c370-5a4e-43e2-9e3a-fcfcbd79be31.jpg","/media/static/23a7bce0-f939-40bf-bde6-5dcbf82c001c.jpg","/media/static/85ae782e-9de9-4f78-be1d-a43a0ccd5e8e.jpg"]', N'[]', 20, 0, 1, CAST(N'2025-01-15T10:41:38.1150000' AS DateTime2), NULL, 5)
INSERT [dbo].[product] ([id], [product_code], [name], [description], [price], [sale_price], [slug], [images], [image_feedback], [product_view], [total_sold], [status], [created_at], [modified_at], [brand_id]) VALUES (N'68i0Rp', N'LNBRN', N'Giày Li-Ning bóng rổ nam', N'<p style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span style="color: rgb(104, 104, 104);">Giày&nbsp;</span><font color="#282828">Li-Ning bóng rổ nam</font><font color="#686868">&nbsp;là một đôi giày chuyên dụng được thiết kế đặc biệt cho các vận động viên nam chơi bóng rổ. Đôi giày này thuộc vào dòng sản phẩm cao cấp của thương hiệu Li-Ning, nổi tiếng với chất lượng và hiệu suất của sản phẩm thể thao.</font></p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Giày có một thiết kế thể thao và mạnh mẽ, mang đến sự tự tin và phong cách cho người mang. Chúng được làm từ chất liệu tổng hợp chất lượng cao, kết hợp với lớp lưới thoáng khí, giúp tăng cường sự thoải mái và đảm bảo sự thông thoáng cho chân trong quá trình chơi bóng rổ.</p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Một trong những điểm nổi bật của giày Li-Ning là hệ thống đệm tiên tiến. Giày được trang bị công nghệ đệm chất lượng cao, giúp giảm sốc và tăng cường sự thoải mái khi nhảy lên và đạp xuống sàn bóng. Điều này giúp bảo vệ xương và khớp chân, và giúp người chơi có thể di chuyển linh hoạt và thực hiện các động tác nhảy cao, chuyền bóng và cắt giữa trận đấu.</p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Đế giày được thiết kế để cung cấp độ bám đất tốt và ổn định. Họa tiết và cấu trúc đế giày được tối ưu hóa để cung cấp sự bám dính và độ linh hoạt khi chuyển động nhanh trên sân bóng rổ. Điều này giúp người chơi có sự kiểm soát tốt hơn khi di chuyển và thực hiện các động tác quan trọng trong trận đấu.</p><h3 33:1-33:277"="" style="margin-top: 1em; margin-bottom: 1em; line-height: 1.4; font-size: 1.56em; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; color: rgb(40, 40, 40); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif;">Thông tin sản phẩm Giày Li-Ning bóng rổ nam</h3><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Thương hiệu:</span>&nbsp;Li-Ning</p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Thiết kế:&nbsp;</span>Li-Ning</p><p style="margin-bottom: 0px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Xuất xứ:</span>&nbsp;Trung Quốc</p>', 1000000, 1490000, N'giay-li-ning-bong-ro-nam', N'["/media/static/c6cb56a3-86cd-4550-86d4-66e32e6f4c1e.jpg","/media/static/b86ad894-f6f5-4458-860a-57647f521579.jpg","/media/static/a11524e9-7a99-419b-bc3f-569facb73173.jpg","/media/static/33f0cd5e-193a-462d-848b-23b4bd138e11.jpg"]', N'[]', 3, 0, 1, CAST(N'2025-01-15T10:47:06.7740000' AS DateTime2), NULL, 3)
INSERT [dbo].[product] ([id], [product_code], [name], [description], [price], [sale_price], [slug], [images], [image_feedback], [product_view], [total_sold], [status], [created_at], [modified_at], [brand_id]) VALUES (N'dbCONI', N'NKPGS', N'Giày (WMNS) Nike Pegasus 40 Premium ‘Pink Acid Wash’', N'<p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Giới thiệu đôi giày thể thao nữ mạnh mẽ nhất –&nbsp;&nbsp;(WMNS) Nike Pegasus 40 Premium ‘Pink Acid Wash’. Được thiết kế để giúp bạn chinh phục những đỉnh cao mới, đôi giày thể thao tuyệt vời này mang đến sự thoải mái, phong cách và hiệu suất tối ưu. Hãy sẵn sàng cách mạng hóa cuộc tập luyện với mỗi bước chạy!</p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Được chế tác với sự tinh tế và chính xác, Nike Pegasus 40 Premium có thiết kế tinh tế sẽ thu hút ánh nhìn trong những chạy tiếp theo của bạn. Với màu hồng ngọc trai/hồng san hô năng động kết hợp với những đường nét nổi bật trắng và xanh đậm, đôi giày thể thao này tỏa ra sự tự tin và thanh lịch.</p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Với công nghệ Zoom đột phá của Nike, Pegasus 40 Premium cung cấp đệm êm tối ưu và hỗ trợ vượt trội. Nó giúp bạn chấm dứt sự không thoải mái và mang đến cuộc chạy nhẹ nhàng, phản ứng nhanh giúp bạn tiếp tục chạy một dặm sau một dặm. Phần trên bằng lưới nhẹ nâng cao sự thoáng khí, đảm bảo đôi chân luôn khô ráo và mát mẻ ngay cả trong những buổi tập luyện căng thẳng nhất.</p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Đôi giày thể thao tuyệt vời này được thiết kế để chinh phục những chặng đường dài nhất và những buổi tập luyện khó nhất của bạn. Nó cung cấp độ bám đường tốt hơn với đế cao su bền, đảm bảo bám vững chắc trên mọi địa hình. Hãy cột dây và trải nghiệm hiệu suất chạy tới tầm cao mới.</p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Vậy tại sao bạn lại chờ đợi? Nâng tầm hiệu suất chạy của bạn với Nike Pegasus 40 Premium và khai phá tiềm năng thật sự của mình. Đặt hàng của bạn ngay hôm nay và chinh phục đường đua như chưa bao giờ có trước đây!</p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Điểm nổi bật:</p><ul style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-left: 0.7em; padding-left: 1.3em; list-style: none; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><li style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;">Công nghệ Zoom của Nike cho đệm êm tối ưu</li><li style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;">Phần trên lưới nhẹ giúp thoáng khí</li><li style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;">Đế cao su bền giúp tăng cường độ bám đường</li><li style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; margin-bottom: 5px;">Kết hợp màu hồng ngọc trai/hồng san hô/trắng/xanh đậm nổi bật</li></ul>', 1500000, 2200000, N'giay-wmns-nike-pegasus-40-premium-pink-acid-wash', N'["/media/static/0d5dc8d5-781b-4008-aa02-6fbe46941512.jpg","/media/static/0076c26f-de87-4035-ab0f-b871e175e819.jpg","/media/static/5bcabd24-f0e9-425f-b153-55b2441ca4e3.jpg","/media/static/b487628f-97d8-47d4-8616-0b8c8410045c.jpg"]', N'[]', 12, 0, 1, CAST(N'2025-01-15T19:09:44.2210000' AS DateTime2), NULL, 1)
INSERT [dbo].[product] ([id], [product_code], [name], [description], [price], [sale_price], [slug], [images], [image_feedback], [product_view], [total_sold], [status], [created_at], [modified_at], [brand_id]) VALUES (N'FqwVjm', N'ADSRDB', N'Giày nam Adidas Runfalcon ‘Dark Blue’', N'<p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: &quot;times new roman&quot;, times; font-size: 14pt;">Giày nam Adidas Runfalcon ‘Dark Blue’&nbsp;đã được bày bán trên Sneaker Daily Shop, đừng bỏ lỡ cơ hội sở hữu cho mình một đôi ngay trước khi sold out nhé!</span></p><p style="margin-bottom: 28px; color: rgb(104, 104, 104); -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"><span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: &quot;times new roman&quot;, times; font-size: 14pt;">Cập nhật nhanh nhất lịch ra mắt của các mẫu giày mới nhất bằng cách theo dõi&nbsp;<span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-weight: bolder;">Sneaker Daily</span>&nbsp;trên&nbsp;Facebook&nbsp;hoặc&nbsp;Instagram.</span></p><h3 style="margin-top: 1em; margin-bottom: 1em; line-height: 1.4; font-size: 1.56em; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; color: rgb(40, 40, 40); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif;"><span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: &quot;times new roman&quot;, times; font-size: 14pt;">Thông tin phát hành adidas Runfalcon ‘Dark Blue’</span></h3><p><divclass="gtx-body" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;"></divclass="gtx-body"></p><div style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;"><divclass="product-footer__details" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;"><p class="product-footer__item-title" style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;"><span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: &quot;times new roman&quot;, times; font-size: 14pt;"><span style="font-weight: bolder; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Thương hiệu:</span>&nbsp;adidas</span></p><p class="product-footer__item-title" style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;"><span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: &quot;times new roman&quot;, times; font-size: 14pt;"><span style="font-weight: bolder; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Thiết kế:&nbsp;</span><a href="https://sneakerdaily.vn/danh-muc-san-pham/adidas-falcon/" style="color: rgb(40, 40, 40); outline-style: initial; outline-width: 0px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; position: relative; display: inline-block; padding: 0.1em 0px; backface-visibility: hidden;">Runfalcon</a></span></p><divclass="product-footer__item" style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;"><p class="product-footer__item-title" style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;"><span style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; font-family: &quot;times new roman&quot;, times; font-size: 14pt;"><span style="font-weight: bolder; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Mã sản phẩm:</span>&nbsp;F36201</span></p><p style="margin-bottom: 0px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;"><span style="font-weight: bolder; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Xuất xứ:&nbsp;</span>Đức</p></divclass="product-footer__item"></divclass="product-footer__details"></div>', 1000000, 1500000, N'giay-nam-adidas-runfalcon-dark-blue', N'["/media/static/93da4a46-91e9-47de-bc35-0e131d0f4839.jpg","/media/static/131f0d46-5ef6-4978-9a8b-7bc7e65f8b97.jpg","/media/static/f1c666b1-195a-4ced-8229-e1d0f81c0583.jpg","/media/static/499c3c38-cdb9-44b1-8484-a3836225156a.jpg"]', N'[]', 2, 0, 1, CAST(N'2025-01-15T18:51:16.6440000' AS DateTime2), NULL, 5)
INSERT [dbo].[product] ([id], [product_code], [name], [description], [price], [sale_price], [slug], [images], [image_feedback], [product_view], [total_sold], [status], [created_at], [modified_at], [brand_id]) VALUES (N'Go9oG2', N'TEST01', N'Sp Test 01', N'<p>Test</p>', 12345, 123456, N'sp-test-01', N'["/media/static/7c408c3e-5396-4fa3-ad37-82aae6e7b7e8.jpg"]', N'[]', 0, 0, 1, CAST(N'2025-01-15T19:13:33.3990000' AS DateTime2), NULL, 3)
INSERT [dbo].[product] ([id], [product_code], [name], [description], [price], [sale_price], [slug], [images], [image_feedback], [product_view], [total_sold], [status], [created_at], [modified_at], [brand_id]) VALUES (N'HIYZf2', N'LNTTN', N'Giày Li-Ning thời trang Nam', N'<div style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Giày Giày Li-Ning thời trang Nam: Phong cách, năng động, thoải mái<p style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;"></p><p style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Đặc điểm nổi bật:</p><p style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Thiết kế thời trang:&nbsp;Kiểu dáng hiện đại, phối màu trẻ trung, dễ phối đồ.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Chất liệu cao cấp: Thân giày bằng da tổng hợp cao cấp, mềm mại, bền đẹp.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Lót trong bằng vải dệt thoáng khí, tạo cảm giác êm ái.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Đế ngoài bằng cao su tổng hợp, chống trơn trượt, tăng độ bám.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Công nghệ tiên tiến:Đệm Li-Ning Cloud: Mang lại cảm giác êm ái, nhẹ nhàng, hỗ trợ tối ưu cho từng bước di chuyển.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Công nghệ TUFF RB: Tăng độ bền, chống mài mòn cho đế giày.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Thoải mái và linh hoạt:&nbsp;Giúp di chuyển nhẹ nhàng, linh hoạt trong mọi hoạt động.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Ưu điểm:</p><p style="margin-bottom: 0px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Thiết kế thời trang, dễ phối đồ.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Chất liệu cao cấp, bền đẹp, tạo cảm giác êm ái.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Công nghệ tiên tiến, hỗ trợ di chuyển thoải mái.<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Giá thành hợp lý.</p></div><div style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility; color: rgb(104, 104, 104); font-family: -apple-system, BlinkMacSystemFont, &quot;Segoe UI&quot;, Roboto, Oxygen-Sans, Ubuntu, Cantarell, &quot;Helvetica Neue&quot;, sans-serif; font-size: 16px;">Hướng dẫn bảo quản:<p style="margin-bottom: 28px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;"></p><p style="margin-bottom: 0px; -webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Lau hoặc giặt nhẹ với nước<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Không sử dụng chất tẩy<br style="-webkit-font-smoothing: antialiased; text-rendering: optimizelegibility;">Tránh phơi trực tiếp dưới ánh nắng gắt</p></div>', 1500000, 1800000, N'giay-li-ning-thoi-trang-nam', N'["/media/static/38d75fb7-862e-4645-9007-a70c1a0728d7.jpg","/media/static/077508e5-b2cf-4636-bef7-a8855f0e5067.jpg","/media/static/3fcc9d62-a174-46ae-8e69-000243263f79.jpg","/media/static/e1ce6e70-53a8-49b2-ac6d-d47f5bc4da42.jpg","/media/static/451fe03a-4a3d-4827-8b2e-9ea013f6b363.jpg"]', N'[]', 2, 0, 1, CAST(N'2025-01-15T18:55:30.1230000' AS DateTime2), NULL, 3)
GO
INSERT [dbo].[product_category] ([product_id], [category_id]) VALUES (N'1SWC07', 2)
INSERT [dbo].[product_category] ([product_id], [category_id]) VALUES (N'68i0Rp', 2)
INSERT [dbo].[product_category] ([product_id], [category_id]) VALUES (N'dbCONI', 4)
INSERT [dbo].[product_category] ([product_id], [category_id]) VALUES (N'FqwVjm', 4)
INSERT [dbo].[product_category] ([product_id], [category_id]) VALUES (N'Go9oG2', 1)
INSERT [dbo].[product_category] ([product_id], [category_id]) VALUES (N'Go9oG2', 2)
INSERT [dbo].[product_category] ([product_id], [category_id]) VALUES (N'HIYZf2', 3)
GO
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'1SWC07', 36, 2)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'1SWC07', 40, 5)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'68i0Rp', 36, 4)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'68i0Rp', 42, 6)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'dbCONI', 36, 1)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'dbCONI', 39, 0)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'FqwVjm', 36, 2)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'FqwVjm', 41, 4)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'Go9oG2', 37, 2)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'Go9oG2', 43, 2)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'HIYZf2', 37, 2)
INSERT [dbo].[product_size] ([product_id], [size], [quantity]) VALUES (N'HIYZf2', 38, 3)
GO
SET IDENTITY_INSERT [dbo].[promotion] ON 

INSERT [dbo].[promotion] ([id], [name], [coupon_code], [discount_type], [discount_value], [maximum_discount_value], [is_active], [is_public], [created_at], [expired_at]) VALUES (1, N'Test', N'TEST', 1, 12, 120000, 1, 1, CAST(N'2025-01-15T12:30:35.6340000' AS DateTime2), CAST(N'2025-01-31T07:00:00.0000000' AS DateTime2))
SET IDENTITY_INSERT [dbo].[promotion] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([id], [full_name], [email], [password], [phone], [address], [avatar], [roles], [status], [created_at], [modified_at]) VALUES (1, N'Admin', N'admin@gmail.com', N'$2a$12$o45hKfKJc8/VSH4aDSj67ei3jB.WxfDaFn1BtTfsLOKP2ctyVLzg6', N'0987654321', NULL, NULL, N'["ADMIN"]', 1, CAST(N'2025-01-15T10:27:21.1440000' AS DateTime2), NULL)
INSERT [dbo].[users] ([id], [full_name], [email], [password], [phone], [address], [avatar], [roles], [status], [created_at], [modified_at]) VALUES (2, N'User', N'user@gmail.com', N'$2a$12$uZjYkkym1g6TxoWAWzdVy.pMs2L.KrUMMsZ.RdzN1q62PP0H8xbEu', N'0345126789', NULL, NULL, N'["USER"]', 1, CAST(N'2025-01-15T19:14:56.7070000' AS DateTime2), NULL)
SET IDENTITY_INSERT [dbo].[users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__brand__72E12F1BE01DA41B]    Script Date: 16/01/2025 10:48:26 SA ******/
ALTER TABLE [dbo].[brand] ADD  CONSTRAINT [UQ__brand__72E12F1BE01DA41B] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__images__A269238197A6C093]    Script Date: 16/01/2025 10:48:26 SA ******/
ALTER TABLE [dbo].[images] ADD  CONSTRAINT [UQ__images__A269238197A6C093] UNIQUE NONCLUSTERED 
(
	[link] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__promotio__ADE5CBB77376A736]    Script Date: 16/01/2025 10:48:26 SA ******/
ALTER TABLE [dbo].[promotion] ADD  CONSTRAINT [UQ__promotio__ADE5CBB77376A736] UNIQUE NONCLUSTERED 
(
	[coupon_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK__comment__product__671F4F74] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([id])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK__comment__product__671F4F74]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK__comment__user_id__662B2B3B] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK__comment__user_id__662B2B3B]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FKs1slvnkuemjsq2kj4h3vhx7i1] FOREIGN KEY([post_id])
REFERENCES [dbo].[post] ([id])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FKs1slvnkuemjsq2kj4h3vhx7i1]
GO
ALTER TABLE [dbo].[images]  WITH CHECK ADD  CONSTRAINT [FK__images__created___7755B73D] FOREIGN KEY([created_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[images] CHECK CONSTRAINT [FK__images__created___7755B73D]
GO
ALTER TABLE [dbo].[order_details]  WITH CHECK ADD  CONSTRAINT [FKftr3hhnbjfadovtpjoiaibtjd] FOREIGN KEY([coupon_code])
REFERENCES [dbo].[promotion] ([coupon_code])
GO
ALTER TABLE [dbo].[order_details] CHECK CONSTRAINT [FKftr3hhnbjfadovtpjoiaibtjd]
GO
ALTER TABLE [dbo].[order_details]  WITH CHECK ADD  CONSTRAINT [FKinivj2k1370kw224lavkm3rqm] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([id])
GO
ALTER TABLE [dbo].[order_details] CHECK CONSTRAINT [FKinivj2k1370kw224lavkm3rqm]
GO
ALTER TABLE [dbo].[order_details]  WITH CHECK ADD  CONSTRAINT [FKjyu2qbqt8gnvno9oe9j2s2ldk] FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([id])
GO
ALTER TABLE [dbo].[order_details] CHECK CONSTRAINT [FKjyu2qbqt8gnvno9oe9j2s2ldk]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK__orders__buyer__607251E5] FOREIGN KEY([buyer])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK__orders__buyer__607251E5]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK__orders__created___625A9A57] FOREIGN KEY([created_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK__orders__created___625A9A57]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK__orders__modified__634EBE90] FOREIGN KEY([modified_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK__orders__modified__634EBE90]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK__orders__product___6166761E] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK__orders__product___6166761E]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FKhtx3insd5ge6w486omk4fnk54] FOREIGN KEY([buyer_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FKhtx3insd5ge6w486omk4fnk54]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FKslhegkjxf2vjeh4uyjyxjd1uj] FOREIGN KEY([coupon_code])
REFERENCES [dbo].[promotion] ([coupon_code])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FKslhegkjxf2vjeh4uyjyxjd1uj]
GO
ALTER TABLE [dbo].[post]  WITH CHECK ADD  CONSTRAINT [FK__post__created_by__70A8B9AE] FOREIGN KEY([created_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[post] CHECK CONSTRAINT [FK__post__created_by__70A8B9AE]
GO
ALTER TABLE [dbo].[post]  WITH CHECK ADD  CONSTRAINT [FK__post__modified_b__719CDDE7] FOREIGN KEY([modified_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[post] CHECK CONSTRAINT [FK__post__modified_b__719CDDE7]
GO
ALTER TABLE [dbo].[product]  WITH CHECK ADD  CONSTRAINT [FK__product__brand_i__56E8E7AB] FOREIGN KEY([brand_id])
REFERENCES [dbo].[brand] ([id])
GO
ALTER TABLE [dbo].[product] CHECK CONSTRAINT [FK__product__brand_i__56E8E7AB]
GO
ALTER TABLE [dbo].[product_category]  WITH CHECK ADD  CONSTRAINT [FK__product_c__categ__5AB9788F] FOREIGN KEY([category_id])
REFERENCES [dbo].[category] ([id])
GO
ALTER TABLE [dbo].[product_category] CHECK CONSTRAINT [FK__product_c__categ__5AB9788F]
GO
ALTER TABLE [dbo].[product_category]  WITH CHECK ADD  CONSTRAINT [FK__product_c__produ__59C55456] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([id])
GO
ALTER TABLE [dbo].[product_category] CHECK CONSTRAINT [FK__product_c__produ__59C55456]
GO
ALTER TABLE [dbo].[product_size]  WITH CHECK ADD  CONSTRAINT [FK__product_s__produ__5D95E53A] FOREIGN KEY([product_id])
REFERENCES [dbo].[product] ([id])
GO
ALTER TABLE [dbo].[product_size] CHECK CONSTRAINT [FK__product_s__produ__5D95E53A]
GO
ALTER TABLE [dbo].[statistic]  WITH CHECK ADD  CONSTRAINT [FKok7jp7mh6y9tghumc2do51ieq] FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([id])
GO
ALTER TABLE [dbo].[statistic] CHECK CONSTRAINT [FKok7jp7mh6y9tghumc2do51ieq]
GO
ALTER TABLE [dbo].[user_used_promotion]  WITH CHECK ADD  CONSTRAINT [FK__user_used__promo__6DCC4D03] FOREIGN KEY([promotion_id])
REFERENCES [dbo].[promotion] ([id])
GO
ALTER TABLE [dbo].[user_used_promotion] CHECK CONSTRAINT [FK__user_used__promo__6DCC4D03]
GO
ALTER TABLE [dbo].[user_used_promotion]  WITH CHECK ADD  CONSTRAINT [FK__user_used__user___6CD828CA] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[user_used_promotion] CHECK CONSTRAINT [FK__user_used__user___6CD828CA]
GO
USE [master]
GO
ALTER DATABASE [TeddySneaker2] SET  READ_WRITE 
GO
