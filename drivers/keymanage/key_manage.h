#ifndef __KEY_MANAGE_H__
#define __KEY_MANAGE_H__

enum key_manager_dev_e{
    KEY_M_UNKNOW_DEV=0,
    KEY_M_EFUSE_NORMAL,
    KEY_M_SECURE_KEY,       //secure nandkey/emmckey
    KEY_M_NORAML_KEY,       //non-secure nandkey/emmckey
    KEY_M_MAX_DEV,
};

/*key data format*/
enum key_manager_df_e{
       KEY_M_HEXDATA=0,
       KEY_M_HEXASCII,
       KEY_M_ALLASCII,
       KEY_M_MAX_DF,
};

enum key_manager_permit_e{
       KEY_M_PERMIT_READ = (1<<0),
       KEY_M_PERMIT_WRITE = (1<<1),
       KEY_M_PERMIT_DEL    = (1<<2),
       KEY_M_PERMIT_MASK   = 0Xf,
};

enum key_manager_type_e{
    KEY_M_TYPE_NORMAL       = 0 ,
    KEY_M_TYPE_MAC              ,
    KEY_M_TYPE_SHA1             ,
    KEY_M_TYPE_HDCP2            ,

    KEY_M_TYPE_TOTAL_NUM
};

#define KEY_UNIFY_NAME_LEN	    48
#define KEY_UNIFY_TYPE_LEN_MAX  ( 16 - 1 )

struct key_item_t{
    char name[KEY_UNIFY_NAME_LEN];
    char keyType[KEY_UNIFY_TYPE_LEN_MAX + 1];//mac/sha1/hdcp2/normal
    char encType[KEY_UNIFY_TYPE_LEN_MAX + 1];//mac/sha1/hdcp2/normal
    int id;
    unsigned int dev; //key save in device //efuse,
    unsigned int datFmt;  //data format
    unsigned int permit;
    int flag;
    int reserv;//reserve and align to 64
};

struct key_info_t{
    int key_num;
    int efuse_version;
    int key_flag;
    int encrypt_type;
};


#endif // #ifndef __KEY_MANAGE_H__

