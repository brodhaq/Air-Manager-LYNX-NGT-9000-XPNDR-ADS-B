function nofunction()
end

function push_number(number)
    flightid = set_char(flightid, flightid_edit_letter, number)  
    
    if flightid_edit_letter < 8 then  
        flightid_edit_letter = flightid_edit_letter + 1
    end
    
    local cursor_x = 97 + (flightid_edit_letter - 1) * 21  
    
    if flightid_edit_letter <= 8 then  
        move(image_cursor, cursor_x, 160)
    end
    
    txt_set(txt_flightid, flightid)
end

function push_backspace()
    if flightid_edit_letter > 1 then
        flightid = set_char(flightid, flightid_edit_letter - 1, " ")
        flightid_edit_letter = flightid_edit_letter - 1
    end
    
    local cursor_x = 97 + (flightid_edit_letter - 1) * 21
    move(image_cursor, cursor_x, 160)
    txt_set(txt_flightid, flightid)
end

function push_done()
    print("Flight ID was set to "..flightid)
    powerstate = 2
    fltid_123_visible(false)
    print("Instrument boot complete")
end

function fltid_123_init()
    image_fltid_123 = img_add_fullscreen("fltid_123.png")
    
    button_1 = button_add("empty.png", "pushed_1.png", 547, 19, 131, 49, nofunction, function() push_number("1") end)
    button_2 = button_add("empty.png", "pushed_2.png", 701, 19, 131, 49, nofunction, function() push_number("2") end)
    button_3 = button_add("empty.png", "pushed_3.png", 855, 19, 131, 49, nofunction, function() push_number("3") end)
    button_4 = button_add("empty.png", "pushed_4.png", 547, 85, 131, 49, nofunction, function() push_number("4") end)
    button_5 = button_add("empty.png", "pushed_5.png", 701, 85, 131, 49, nofunction, function() push_number("5") end)
    button_6 = button_add("empty.png", "pushed_6.png", 855, 85, 131, 49, nofunction, function() push_number("6") end)
    button_7 = button_add("empty.png", "pushed_7.png", 547, 151, 131, 49, nofunction, function() push_number("7") end)
    button_8 = button_add("empty.png", "pushed_8.png", 701, 151, 131, 49, nofunction, function() push_number("8") end)
    button_9 = button_add("empty.png", "pushed_9.png", 855, 151, 131, 49, nofunction, function() push_number("9") end)
    button_0 = button_add("empty.png", "pushed_0.png", 701, 217, 131, 49, nofunction, function() push_number("0") end)
    
    button_backspace = button_add("empty.png", "pushed_backspace.png", 413, 113, 81, 57, nofunction, push_backspace)    
    button_done = button_add("empty.png", "pushed_done.png", 366, 5, 124, 34, nofunction, push_done)   
    button_am = button_add("empty.png", "pushed_am.png", 313, 205, 83, 73, nofunction, function()  
      fltid_nz_visible(false)  -- Hide N-Z keyboard
      fltid_am_visible(true)   -- Show A-M keyboard
      fltid_123_visible(false)  -- Hide 123 keyboard
    end)
    button_nz = button_add("empty.png", "pushed_nz.png", 413, 205, 83, 73, nofunction, function()  
      fltid_am_visible(false)  -- Hide A-M keyboard
      fltid_nz_visible(true)   -- Show N-Z keyboard
      fltid_123_visible(false)  -- Hide 123 keyboard
    end)
    txt_flightid = txt_add(flightid, "font:Menlo-Regular.ttf; size:40; color: #13ff00; halign:left;", 97, 127, 237, 33)
end

function fltid_123_visible(is_visible)
    visible(image_fltid_123, is_visible)
    visible(txt_flightid, is_visible)
    
    visible(button_1, is_visible)
    visible(button_2, is_visible)
    visible(button_3, is_visible)
    visible(button_4, is_visible)
    visible(button_5, is_visible)
    visible(button_6, is_visible)
    visible(button_7, is_visible)
    visible(button_8, is_visible)
    visible(button_9, is_visible)
    visible(button_0, is_visible)
    visible(button_backspace, is_visible)
    visible(button_done, is_visible)
    visible(button_am, is_visible)
    visible(button_nz, is_visible)
end
