/*
 Navicat Premium Dump SQL

 Source Server         : 本地 Mysql
 Source Server Type    : MySQL
 Source Server Version : 80037 (8.0.37)
 Source Host           : localhost:3306
 Source Schema         : sinan_dev

 Target Server Type    : MySQL
 Target Server Version : 80037 (8.0.37)
 File Encoding         : 65001

 Date: 29/08/2025 13:12:14
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sn_bookmark
-- ----------------------------
DROP TABLE IF EXISTS `sn_bookmark`;
CREATE TABLE `sn_bookmark` (
  `id` varchar(64) NOT NULL COMMENT '书签ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '用户ID',
  `space_id` varchar(64) DEFAULT NULL COMMENT '空间',
  `name` varchar(256) DEFAULT NULL COMMENT '书签名称',
  `pinyin` varchar(512) DEFAULT NULL,
  `abbreviation` varchar(64) DEFAULT NULL COMMENT '简写-自动生成首字母',
  `description` varchar(256) DEFAULT NULL COMMENT '书签描述',
  `url` varchar(1024) NOT NULL COMMENT '书签url',
  `icon` text COMMENT '书签Icon',
  `num` int DEFAULT NULL COMMENT '使用次数',
  `star` tinyint(1) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='书签';

-- ----------------------------
-- Table structure for sn_bookmark_ass_tag
-- ----------------------------
DROP TABLE IF EXISTS `sn_bookmark_ass_tag`;
CREATE TABLE `sn_bookmark_ass_tag` (
  `id` varchar(64) NOT NULL COMMENT '书签ID',
  `user_id` varchar(64) NOT NULL COMMENT '用户ID',
  `bookmark_id` varchar(64) NOT NULL COMMENT '书签ID',
  `tag_id` varchar(64) NOT NULL COMMENT '标签ID',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='书签关联标签';

-- ----------------------------
-- Table structure for sn_pass_key
-- ----------------------------
DROP TABLE IF EXISTS `sn_pass_key`;
CREATE TABLE `sn_pass_key` (
  `id` varchar(50) NOT NULL COMMENT 'id',
  `user_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'userId',
  `credential_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'credentialId',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT 'name',
  `public_key` blob,
  `aaguid` blob,
  `signature_count` bigint NOT NULL DEFAULT '-1' COMMENT 'signatureCount',
  `attestation_object` blob,
  `client_data_json` blob,
  `create_time` datetime NOT NULL DEFAULT '1000-01-01 00:00:00' COMMENT 'createTime',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'updateTime',
  `last_used` datetime NOT NULL DEFAULT '1000-01-01 00:00:00' COMMENT 'lastUsed',
  `deleted` int NOT NULL DEFAULT '0' COMMENT 'deleted',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='sn_pass_key';

-- ----------------------------
-- Table structure for sn_pass_key_challenge
-- ----------------------------
DROP TABLE IF EXISTS `sn_pass_key_challenge`;
CREATE TABLE `sn_pass_key_challenge` (
  `id` varchar(50) NOT NULL COMMENT 'id',
  `challenge` blob COMMENT '挑战',
  `user_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'userId',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT 'email',
  `challenge_type` varchar(50) NOT NULL DEFAULT '' COMMENT 'challengeType',
  `expire_time` datetime NOT NULL DEFAULT '1000-01-01 00:00:00' COMMENT 'expireTime',
  `create_time` datetime NOT NULL DEFAULT '1000-01-01 00:00:00' COMMENT 'createTime',
  `used` int NOT NULL DEFAULT '-1' COMMENT 'used',
  `deleted` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='sn_pass_key_challenge';

-- ----------------------------
-- Table structure for sn_share_space_ass_user
-- ----------------------------
DROP TABLE IF EXISTS `sn_share_space_ass_user`;
CREATE TABLE `sn_share_space_ass_user` (
  `id` varchar(64) NOT NULL COMMENT '书签ID',
  `user_id` varchar(64) NOT NULL COMMENT '用户ID',
  `space_id` varchar(64) NOT NULL COMMENT '空间ID',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='分享关联用户';

-- ----------------------------
-- Table structure for sn_space
-- ----------------------------
DROP TABLE IF EXISTS `sn_space`;
CREATE TABLE `sn_space` (
  `id` varchar(64) NOT NULL COMMENT '书签ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '用户ID',
  `name` varchar(64) DEFAULT NULL COMMENT '空间名称',
  `pinyin` varchar(256) DEFAULT NULL COMMENT '拼音',
  `abbreviation` varchar(64) DEFAULT NULL COMMENT '简写-自动生成首字母',
  `icon` varchar(256) DEFAULT NULL,
  `sort` int DEFAULT NULL COMMENT '排序',
  `share` tinyint(1) DEFAULT '0' COMMENT '是否分享',
  `share_key` varchar(64) DEFAULT '' COMMENT '分享密码',
  `description` varchar(256) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='空间';

-- ----------------------------
-- Table structure for sn_tag
-- ----------------------------
DROP TABLE IF EXISTS `sn_tag`;
CREATE TABLE `sn_tag` (
  `id` varchar(64) NOT NULL COMMENT '书签ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '用户ID',
  `name` varchar(64) DEFAULT NULL COMMENT '空间名称',
  `pinyin` varchar(256) DEFAULT NULL COMMENT '拼音',
  `abbreviation` varchar(64) DEFAULT NULL COMMENT '简写-自动生成首字母',
  `color` varchar(32) DEFAULT NULL COMMENT '颜色',
  `sort` int DEFAULT '0' COMMENT '排序',
  `description` varchar(256) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='空间';

-- ----------------------------
-- Table structure for sn_user
-- ----------------------------
DROP TABLE IF EXISTS `sn_user`;
CREATE TABLE `sn_user` (
  `id` varchar(64) NOT NULL COMMENT '书签ID',
  `name` varchar(64) DEFAULT NULL COMMENT '空间名称',
  `avatar` varchar(256) DEFAULT NULL COMMENT '用户头像',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户';

-- ----------------------------
-- Table structure for sn_user_credential
-- ----------------------------
DROP TABLE IF EXISTS `sn_user_credential`;
CREATE TABLE `sn_user_credential` (
  `id` varchar(64) NOT NULL COMMENT '书签ID',
  `user_id` varchar(64) NOT NULL COMMENT '用户ID',
  `credential_type` varchar(64) NOT NULL COMMENT '凭证类型',
  `credential` varchar(64) NOT NULL COMMENT '凭证',
  `params` text COMMENT '额外参数',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='凭证';

-- ----------------------------
-- Table structure for sn_user_key
-- ----------------------------
DROP TABLE IF EXISTS `sn_user_key`;
CREATE TABLE `sn_user_key` (
  `id` varchar(64) NOT NULL COMMENT '书签ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '用户ID',
  `name` varchar(64) DEFAULT NULL,
  `access_key` varchar(64) DEFAULT NULL COMMENT '访问密钥',
  `description` varchar(256) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户密钥';

SET FOREIGN_KEY_CHECKS = 1;
