function nofunction()
end

function usetail()
    flightid = user_prop_get(title_tailnumber)
    print("Flight ID was set to "..flightid)
    powerstate = 2
    fltid_nz_visible(false)
    print("Instrument boot complete")
end

function push_letter(letter)
    flightid = set_char(flightid, flightid_edit_letter, letter)  
    
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
    if flightid_edit_letter == 1 then
        flightid = set_char(flightid, 1, " ")
        flightid_edit_letter = 1
    elseif flightid_edit_letter == 8 then
        local current_char = string.sub(flightid, 8, 8)
        if current_char ~= " " then
            flightid = set_char(flightid, 8, " ")
        else
            flightid = set_char(flightid, 7, " ")
            flightid_edit_letter = 7
        end
    else
        local current_char = string.sub(flightid, flightid_edit_letter - 1, flightid_edit_letter - 1)
        if current_char ~= " " then
            flightid = set_char(flightid, flightid_edit_letter - 1, " ")
        end
        flightid_edit_letter = flightid_edit_letter - 1
    end

    local cursor_x = 97 + (flightid_edit_letter - 1) * 21
    move(image_cursor, cursor_x, 160)
    txt_set(txt_flightid, flightid)
end

function push_done()
    print("Flight ID was set to "..flightid)
    powerstate = 2
    fltid_am_visible(false)  -- Hide A-M keyboard if active
    fltid_nz_visible(false)  -- Hide N-Z keyboard if active
    print("Instrument boot complete")
end


function fltid_nz_init()
    image_fltid_nz = img_add_fullscreen("fltid_nz.png")
    button_n = button_add("empty.png", "pushed_n.png", 551,5,83,73, nofunction, function() push_letter("N") end)
    button_o = button_add("empty.png", "pushed_o.png", 652,5,83,73, nofunction, function() push_letter("O") end)
    button_p = button_add("empty.png", "pushed_p.png", 753,5,83,73, nofunction, function() push_letter("P") end)
    button_q = button_add("empty.png", "pushed_q.png", 854,5,83,73, nofunction, function() push_letter("Q") end)
    button_r = button_add("empty.png", "pushed_r.png", 551,106,83,73, nofunction, function() push_letter("R") end)
    button_s = button_add("empty.png", "pushed_s.png", 652,106,83,73, nofunction, function() push_letter("S") end)
    button_t = button_add("empty.png", "pushed_t.png", 753,106,83,73, nofunction, function() push_letter("T") end)
    button_u = button_add("empty.png", "pushed_u.png", 854,106,83,73, nofunction, function() push_letter("U") end)
    button_v = button_add("empty.png", "pushed_v.png", 509,205,83,73, nofunction, function() push_letter("V") end)
    button_w = button_add("empty.png", "pushed_w.png", 610,205,83,73, nofunction, function() push_letter("W") end)
    button_x = button_add("empty.png", "pushed_x.png", 711,205,83,73, nofunction, function() push_letter("X") end)
    button_y = button_add("empty.png", "pushed_y.png", 812,205,83,73, nofunction, function() push_letter("Y") end)
    button_z = button_add("empty.png", "pushed_z.png", 913,205,83,73, nofunction, function() push_letter("Z") end)
    button_backspace = button_add("empty.png", "pushed_backspace.png", 413,113,81,57, nofunction, push_backspace)    
    button_done = button_add("empty.png", "pushed_done.png", 366,5,124,34, nofunction, push_done)   
    button_usetail = button_add("empty.png", "pushed_usetail.png", 157,5,182,34,nofunction, usetail)
    button_am = button_add("empty.png", "pushed_am.png", 313, 205, 83, 73, nofunction, function()  
       print("Switching to A-M keyboard")  -- Debug output
       fltid_nz_visible(false)  -- Hide N-Z keyboard
       fltid_am_visible(true)   -- Show A-M keyboard
       fltid_123_visible(false)  -- Hide 123 keyboard
    end)

    button_123 = button_add("empty.png", "pushed_123.png", 211, 205, 83, 73, nofunction, function()  
      fltid_am_visible(false)   -- Hide A-M keyboard
      fltid_nz_visible(false)   -- Hide N-Z keyboard
      fltid_123_visible(true)  -- Show 123 keyboard
    end)
    txt_flightid = txt_add(flightid, "font:Menlo-Regular.ttf; size:40; color: #13ff00; halign:left;", 97, 127, 237, 33)
end

function fltid_nz_visible(is_visible)
    visible(image_fltid_nz, is_visible)
    visible(txt_flightid, is_visible)
    visible(button_n, is_visible)
    visible(button_o, is_visible)
    visible(button_p, is_visible)
    visible(button_q, is_visible)
    visible(button_r, is_visible)
    visible(button_s, is_visible)
    visible(button_t, is_visible)
    visible(button_u, is_visible)
    visible(button_v, is_visible)
    visible(button_w, is_visible)
    visible(button_x, is_visible)
    visible(button_y, is_visible)
    visible(button_z, is_visible)
    visible(button_backspace, is_visible)
    visible(button_done, is_visible)
    visible(button_usetail, is_visible)
    visible(button_am, is_visible)
    visible(button_123, is_visible)
end
