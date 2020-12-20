local checks = require('checks')
local errors = require('errors')
local log = require('log')

local err_storage = errors.new_class("Storage error")

local function init_space()
    
    -- offers

    local offers = box.schema.space.create(
        'offers',
        {
            format = {
                {'id', 'unsigned'},
                {'bucket_id', 'unsigned'},
                {'title', 'string'},
                {'preview', 'string'},
                {'description', 'string'},
                {'promocode', 'string'},
                {'promocode_type', 'string'}, -- personal or common
                {'is_active', 'boolean'},
                {'categories', 'array'},
                {'brands', 'array'},
                {'show_from', 'unsigned'}, -- just in case if some offers preview has to be shown before valid_from date
                {'valid_from', 'unsigned'},
                {'valid_to', 'unsigned'}
            },
            if_not_exists = true,
            engine = 'memtx',
            temporary = false -- probably default value (!)
        }
    )

    offers:create_index('id', {
        parts = {'id'},
        unique = true,
        if_not_exists = true
    })

    offers:create_index('bucket_id', {
        parts = {'bucket_id'},
        unique = false,
        if_not_exists = true,
    })

    -- categories

    local categories = box.schema.space.create(
        'categories',
        {
            format = {
                {'id', 'unsigned'},
                {'bucket_id', 'unsigned'},
                {'name', 'string'},
                {'code', 'string'},
                {'sort', 'unsigned'}
            },
            if_not_exists = true,
            engine = 'memtx',
            temporary = false,
        }
    )

    categories:create_index('id', {
        parts = {'id'},
        if_not_exists = true
    })

    categories:create_index('bucket_id', {
        parts = {'bucket_id'},
        if_not_exists = true
    })

    categories:create_index('name', {
        parts = {'name'},
        unique = false,
        if_not_exists = true
    })

    -- brands

    local brands = box.schema.space.create(
        'brands', -- спейс для хранения брендов
        {
            format = {
                {'id', 'unsigned'},
                {'bucket_id', 'unsigned'},
                {'name', 'string'},
                {'code', 'string'},
                {'sort', 'unsigned'}
            },
            if_not_exists = true,
            engine = 'memtx',
            temporary = false,
        }
    )

    brands:create_index('id', {
        parts = {'id'},
        if_not_exists = true
    })

    brands:create_index('bucket_id', {
        parts = {'bucket_id'},
        if_not_exists = true
    })

    brands:create_index('name', {
        parts = {'name'},
        unique = false,
        if_not_exists = true
    })

    -- shopping_malls

    local malls = box.schema.space.create(
        'malls', -- тороговые центры
        {
            format = {
                {'id', 'unsigned'},
                {'bucket_id', 'unsigned'},
                {'name', 'string'},
                {'sort', 'unsigned'}
            },
            if_not_exists = true,
            engine = 'memtx',
            temporary = false,
        }
    )

    malls:create_index('id', {
        parts = {'id'},
        if_not_exists = true
    })

    malls:create_index('bucket_id', {
        parts = {'bucket_id'},
        if_not_exists = true
    })

    malls:create_index('name', {
        parts = {'name'},
    })
end