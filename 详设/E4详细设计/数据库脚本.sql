drop table if exists t_approval_flow;

drop table if exists t_approval_flow_info;

drop table if exists t_approval_log;

drop table if exists t_basic_config;

drop table if exists t_business_data_map;

drop table if exists t_business_domain_map;

drop table if exists t_business_table_map;

drop table if exists t_department;

drop table if exists t_model;

drop table if exists t_model_compile_log;

drop table if exists t_model_layout;

drop table if exists t_node_approvers_rules;

drop table if exists t_node_basic;

drop table if exists t_node_branch_line_rules;

drop table if exists t_node_branch_rules;

drop table if exists t_node_complete_rules;

drop table if exists t_node_config;

drop table if exists t_node_event;

drop table if exists t_node_gather_rules;

drop table if exists t_node_notice;

drop table if exists t_node_notice_user;

drop table if exists t_node_rule;

drop table if exists t_node_send_rules;

drop table if exists t_node_vector;

drop table if exists t_notice_template;

drop table if exists t_organization;

drop table if exists t_position;

drop table if exists t_role;

drop table if exists t_type_class;

drop table if exists t_type_code;

drop table if exists t_user_role;

drop table if exists t_userinfo;

/*==============================================================*/
/* Table: t_approval_flow                                       */
/*==============================================================*/
create table t_approval_flow
(
   id                   varchar(64) not null comment '申请id',
   model_id             bigint comment '流程模板id',
   apply_id             varchar(64) comment '申请人 用户表用户id',
   approval_status      smallint comment '整个审批中的流转状态 0-初始状态 1-审批中 2-已通过 3-拒绝',
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   approve_time         bigint comment '审批完成时间',
   parent_id            varchar(64) comment '申请实例关联 如果为null表示父实例 如果有记录 表示 该实例属于驳回重新生成的实例 父实例id代表原来实例',
   instance_bin_id      varchar(64) comment '用户语言实例执行id',
   primary key (id)
);

alter table t_approval_flow comment '审批流申请具体一个个流程实例';

/*==============================================================*/
/* Table: t_approval_flow_info                                  */
/*==============================================================*/
create table t_approval_flow_info
(
   id                   varchar(32) not null,
   approval_flow_id     varchar(64) comment 't_approval_flow 审批流申请实例主键',
   business_data_id     varchar(64) comment 't_business_data业务数据主键',
   data_name            varchar(512) comment '冗余t_business_data的data_name字段',
   data_value           varchar(256) comment '具体申请是填写的数据值',
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   data_symbol          varchar(20) comment '冗余t_business_data的data_symbol字段',
   primary key (id)
);

alter table t_approval_flow_info comment '审批流申请基本信息 该审批流需要具体填写的数据值';

/*==============================================================*/
/* Table: t_approval_log                                        */
/*==============================================================*/
create table t_approval_log
(
   id                   varchar(64) not null comment '申请id',
   approval_flow_id     varchar(64) comment 't_approval_flow主键',
   approve_id           varchar(64) comment '审批人关联用户主键id',
   record_status        smallint comment '0-未审批 1审批中: 2:通过 3:拒绝',
   approve_content      varchar(512) comment '比如审批不通过的具体原因',
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   node_approve_status  smallint comment '0-未审批 1审批中: 2:通过 3:拒绝 流转该节点整体的审批状态 比如十个人只需要8个人通过 则该状态通过 另外两个人不需要审核',
   node_basic_id        varchar(64) comment 't_node_basic主键id 该节点对应的审批人',
   primary key (id)
);

alter table t_approval_log comment '审批记录';

/*==============================================================*/
/* Table: t_basic_config                                        */
/*==============================================================*/
create table t_basic_config
(
   id                   varchar(64) not null comment '申请id',
   model_id             varchar(64) comment '流程模板id',
   operation_type       varchar(10) comment 'initiate-申请可发起人view-申请可查看人员',
   target_type          varchar(10) comment 'departments-部门roles-角色 users-用户
            
            ',
   target_id            varchar(64) comment '对应部门id  角色id 用户id',
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_basic_config comment '基础设置 针对每个流程模板都可以根据操作类型 比如发起人或者查看人 选择按角色或者部门或者具体到人来设置';

/*==============================================================*/
/* Table: t_business_data_map                                   */
/*==============================================================*/
create table t_business_data_map
(
   id                   varchar(64) not null comment '平台业务数据表id',
   field_id             bigint comment '领域数据库id',
   filedtable_row_id    bigint comment '领域数据行id',
   model_id             varchar(64) comment '流程模板主键id',
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_business_data_map comment '业务数据领域表映射表';

/*==============================================================*/
/* Table: t_business_domain_map                                 */
/*==============================================================*/
create table t_business_domain_map
(
   field_id             bigint not null,
   primary key (field_id)
);

alter table t_business_domain_map comment '领域数据映射表';

/*==============================================================*/
/* Table: t_business_table_map                                  */
/*==============================================================*/
create table t_business_table_map
(
   id                   bigint not null,
   model_id             varchar(64) comment '流程模板主键id',
   primary key (id)
);

alter table t_business_table_map comment '领域数据库映射表';

/*==============================================================*/
/* Table: t_department                                          */
/*==============================================================*/
create table t_department
(
   id                   varchar(64) not null,
   node_id              varchar(32),
   department_name      varchar(64),
   manager_id           varchar(64),
   department_status    smallint,
   parent_id            varchar(64),
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   organization_id      varchar(64),
   primary key (id)
);

alter table t_department comment '审批流部门(组织架构)';

/*==============================================================*/
/* Table: t_model                                               */
/*==============================================================*/
create table t_model
(
   id                   varchar(64) not null,
   node_id              varchar(32),
   model_name           varchar(64),
   model_status         smallint,
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   bin_id               varchar(64) comment '用户语言返回的id',
   primary key (id)
);

alter table t_model comment '审批流模板';

/*==============================================================*/
/* Table: t_model_compile_log                                   */
/*==============================================================*/
create table t_model_compile_log
(
   id                   varchar(64) not null,
   operation            varchar(32) comment '定义的操作步骤 比如1-启动 2-完成',
   result               smallint comment '1-成功 2-失败',
   remark               varchar(255) comment '备注内容:比如编译通过',
   model_id             varchar(64) comment '流程模板主键id',
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_model_compile_log comment '审批流模板编译日志
';

/*==============================================================*/
/* Table: t_model_layout                                        */
/*==============================================================*/
create table t_model_layout
(
   id                   varchar(64) not null,
   流程模板id               varchar(64) comment '流程模板id',
   布局内容json             varchar(4000) comment '布局具体细节json内容',
   primary key (id)
);

alter table t_model_layout comment '审批流模板布局图主要存储审批流原图信息';

/*==============================================================*/
/* Table: t_node_approvers_rules                                */
/*==============================================================*/
create table t_node_approvers_rules
(
   id                   varchar(64) not null,
   node_basic_id        varchar(64) comment 't_node_basic主键id 只有人工节点才有',
   node_rule_id         varchar(64) comment 't_node_rule主键id',
   target_type          smallint comment '1-部门2-角色 3-用户',
   target_id            varchar(64) comment '部门id 角色id 用户id',
   primary key (id)
);

alter table t_node_approvers_rules comment '审批人规则 主要选择相关人员角色等 人工节点才有';

/*==============================================================*/
/* Table: t_node_basic                                          */
/*==============================================================*/
create table t_node_basic
(
   id                   varchar(32) not null,
   node_type            varchar(20) comment '枚举值:0-开始节点 1-结束节点 2-人工节点 3-条件分支节点4- 条件聚合节点 5-抄送节点 6- 普通线 7-分支线 ',
   node_name            varchar(256) comment '如部门经理审批 名字可以不唯一',
   model_id             varchar(64) comment 't_model审批流模板id
            t_model申请流模板id',
   node_remark          varchar(128) comment '节点标识符唯一 比如:departmentmanager ',
   primary key (id)
);

alter table t_node_basic comment '流程基本节点表 每个画布的节点和线';

/*==============================================================*/
/* Table: t_node_branch_line_rules                              */
/*==============================================================*/
create table t_node_branch_line_rules
(
   id                   varchar(64) not null,
   branch_rule_id       varchar(64) comment 't_node_branch_rules分支节点规则id',
   node_basic_id        varchar(64) comment 't_node_basic主键id 只有分支线节点才有',
   primary key (id)
);

alter table t_node_branch_line_rules comment '分支线执行规则';

/*==============================================================*/
/* Table: t_node_branch_rules                                   */
/*==============================================================*/
create table t_node_branch_rules
(
   id                   varchar(64) not null,
   node_rule_id         varchar(64) comment 't_node_rule主键id',
   node_basic_id        varchar(64) comment 't_node_basic主键id 只有分支节点才有',
   rule_name            varchar(256),
   rule_condition       varchar(2000) comment 'json串 {key:''审批表id'',condtion:"等于",val：“1”}',
   primary key (id)
);

alter table t_node_branch_rules comment '流程分支规则 针对条件分支节点时';

/*==============================================================*/
/* Table: t_node_complete_rules                                 */
/*==============================================================*/
create table t_node_complete_rules
(
   id                   varchar(64) not null,
   node_basic_id        varchar(64) comment 't_node_basic主键id 只有人工节点才有',
   node_rule_id         varchar(64) comment 't_node_rule主键id',
   type                 smallint comment '1-通过 2-不通过',
   action               varchar(64) comment '不通过时 执行的动作返回的节点id 默认空 通过为空',
   rule_content         varchar(256) comment 'json字符串 {type:''只要'',cnt：’1人‘}',
   primary key (id)
);

alter table t_node_complete_rules comment '完成规则 主要该流程的完成规则 人工节点才有';

/*==============================================================*/
/* Table: t_node_config                                         */
/*==============================================================*/
create table t_node_config
(
   id                   varchar(64) not null comment '申请id',
   node_name            varchar(64) comment 't_node_basic的节点名称字段 冗余(处理人工节点和申请人)',
   model_id             varchar(64) comment '审批流模板id',
   node_basic_id        varchar(64) comment 't_node_basic主键id 如果类型是2申请人 就是用户id',
   type                 smallint comment '1-人工节点 2-申请人',
   data_visiable_ids    varchar(512) comment 'data_id数组 业务数据的主键数组',
   data_editable_ids    varchar(512) comment 'data_id数组 业务数据的主键数组',
   data_require_ids     varchar(512) comment 'data_id数组 业务数据的主键数组',
   node_status          smallint,
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_node_config comment '节点设置';

/*==============================================================*/
/* Table: t_node_event                                          */
/*==============================================================*/
create table t_node_event
(
   id                   varchar(32) not null,
   event_type           varchar(32) comment '流程流经改节点事件enter 流程流经离开节点事件leave',
   event_condition      varchar(64) comment '{type:"sendmsg"}',
   node_basic_id        varchar(64) comment 't_node_basic主键id',
   primary key (id)
);

alter table t_node_event comment '流程事件表';

/*==============================================================*/
/* Table: t_node_gather_rules                                   */
/*==============================================================*/
create table t_node_gather_rules
(
   id                   varchar(64) not null,
   node_basic_id        varchar(64) comment 't_node_basic主键id 该节点对应的审批人',
   node_rule_id         varchar(64) comment 't_node_rule主键id',
   gather_rule          varchar(64) comment '1-必须全部通过 2-至少一个通过',
   primary key (id)
);

alter table t_node_gather_rules comment '分支聚合节点聚合规则';

/*==============================================================*/
/* Table: t_node_notice                                         */
/*==============================================================*/
create table t_node_notice
(
   id                   varchar(64) not null,
   node_config_id    varchar(64) comment 't_node_config 主键 人工节点id',
   notice_template_id   varchar(64) comment 't_notice_template 主键',
   notice_way           smallint comment '1-短信 2-邮件 冗余消息模板通知方式字段',
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_node_notice comment '每个人工节点消息通知设置';

/*==============================================================*/
/* Table: t_node_notice_user                                    */
/*==============================================================*/
create table t_node_notice_user
(
   id                   varchar(64) not null,
   node_notice_id       varchar(64) comment 't_node_notice节点通知主键',
   target_type          smallint comment '1-部门2-角色 3-用户',
   target_id            varchar(64) comment '部门id 角色id 用户id',
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_node_notice_user comment '节点消息通知人员';

/*==============================================================*/
/* Table: t_node_rule                                           */
/*==============================================================*/
create table t_node_rule
(
   id                   varchar(32) not null,
   role_type            smallint comment '1-审批人规则 2-完成人规则 3- 自动执行规则 4-分支规则 5-聚合规则  6-抄送人规则 7-线执行规则',
   model_id             varchar(64) comment 't_model审批流模板id
            t_model申请流模板id',
   node_basic_id        varchar(64) comment 't_node_basic主键id',
   primary key (id)
);

alter table t_node_rule comment '流程规则表';

/*==============================================================*/
/* Table: t_node_send_rules                                     */
/*==============================================================*/
create table t_node_send_rules
(
   id                   varchar(64) not null,
   node_basic_id        varchar(64) comment 't_node_basic主键id 只有抄送节点才有',
   node_rule_id         varchar(64) comment 't_node_rule主键id',
   target_type          smallint comment '1-部门2-角色 3-用户',
   target_id            varchar(64) comment '部门id 角色id 用户id',
   primary key (id)
);

alter table t_node_send_rules comment '抄送人抄送节点规则';

/*==============================================================*/
/* Table: t_node_vector                                         */
/*==============================================================*/
create table t_node_vector
(
   id                   varchar(32) not null,
   origin_id            varchar(64) comment '流程节点的主键 普通线或分支线开始节点',
   target_id            varchar(64) comment '流程节点的主键 普通线或分支线结尾节点',
   model_id             varchar(64) comment 't_model审批流模板id
            t_model申请流模板id',
   node_basic_id        varchar(64) comment 't_node_basic主键id 普通线 分支线',
   vector_type          smallint comment '1-普通 2-分支',
   primary key (id)
);

alter table t_node_vector comment '流程线(方向表)';

/*==============================================================*/
/* Table: t_notice_template                                     */
/*==============================================================*/
create table t_notice_template
(
   id                   varchar(64) not null comment '申请id',
   notice_name          varchar(64) comment '如短信通知',
   organization_id      varchar(64),
   notice_way           smallint comment '1-短信 2-邮件',
   notice_title         varchar(64),
   notice_content       varchar(512) comment '模板编译 通过字段模板(字段模板字段来源于标识字段)编译 最终通过业务数据时间填写的内容填充',
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_notice_template comment '审批流消息模板';

/*==============================================================*/
/* Table: t_organization                                        */
/*==============================================================*/
create table t_organization
(
   id                   varchar(32) not null,
   organization_id      varchar(32),
   name                 varchar(64),
   developer_id         varchar(32),
   organization_status  smallint,
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_organization comment '审批流组织表';

/*==============================================================*/
/* Table: t_position                                            */
/*==============================================================*/
create table t_position
(
   id                   varchar(64) not null comment '申请id',
   position_name        varchar(64),
   department_id        varchar(64),
   position_status      smallint,
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_position comment '岗位表';

/*==============================================================*/
/* Table: t_role                                                */
/*==============================================================*/
create table t_role
(
   id                   varchar(64) not null,
   role_name            varchar(64),
   role_status          smallint,
   parent_id            varchar(64),
   organization_id      bigint comment 't_organization',
   remark               varchar(128),
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_role comment '审批流角色表';

/*==============================================================*/
/* Table: t_type_class                                          */
/*==============================================================*/
create table t_type_class
(
   id                   varchar(64) not null comment '申请id',
   type_class           varchar(64),
   remark               varchar(128),
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint
);

alter table t_type_class comment '系统字典分类表';

/*==============================================================*/
/* Table: t_type_code                                           */
/*==============================================================*/
create table t_type_code
(
   id                   varchar(64) not null comment '申请id',
   type_class           varchar(64),
   type_name            varchar(128),
   type_code            varchar(32),
   remark               varchar(128),
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint
);

alter table t_type_code comment '系统字典表';

/*==============================================================*/
/* Table: t_user_role                                           */
/*==============================================================*/
create table t_user_role
(
   id                   varchar(64) not null,
   user_id              varchar(64),
   role_id              varchar(64),
   create_id            varchar(64),
   update_id            varchar(64),
   create_time          bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_user_role comment '用户角色表';

/*==============================================================*/
/* Table: t_userinfo                                            */
/*==============================================================*/
create table t_userinfo
(
   id                   varchar(64) not null,
   user_number          varchar(64),
   user_name            varchar(128),
   department_id        varchar(64),
   position_id          varchar(64),
   parent_id            varchar(64),
   user_status          smallint,
   email                varchar(256),
   mobile               varchar(20),
   sex                  varchar(2),
   create_id            varchar(64),
   update_id            varchar(64),
   crreate_time         bigint,
   update_time          bigint,
   primary key (id)
);

alter table t_userinfo comment '审批流用户表';
