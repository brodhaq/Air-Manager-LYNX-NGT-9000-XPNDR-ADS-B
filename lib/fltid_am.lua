function nofunction()
end

function usetail()
    flightid = user_prop_get(title_tailnumber)
    print("Flight ID was set to "..flightid)
    powerstate = 2
    fltid_am_visible(false)
    print("Instrument boot complete")
end

function set_char(str, index, new_char)
    if index < 1 or index > #str then
        return str  -- Return original string if index is out of bounds
    end
    return str:sub(1, index - 1) .. new_char .. str:sub(index + 1)
end

function push_letter(letter)
    -- Replace the character at the current position
    flightid = set_char(flightid, flightid_edit_letter, letter)  
    
    -- Move to the next letter position if not at the last character
    if flightid_edit_letter < 8 then  
        flightid_edit_letter = flightid_edit_letter + 1
    end
    
    -- Move the cursor right by 24px if we are at position 2 or more, and ensure it doesn't go beyond position 8
    local cursor_x = 97 + (flightid_edit_letter - 1) * 21  -- 97 is the starting position of the cursor, 24px per position
    
    if flightid_edit_letter <= 8 then  -- Prevent moving the cursor past position 8
        -- Update the cursor's position
        move(image_cursor, cursor_x, 160)
    end
    
    -- Update display with the modified flightid
    txt_set(txt_flightid, flightid)
end


function push_backspace()
    if flightid_edit_letter == 1 then
        -- For position 1, set it to space (no previous character), stay at position 1
        flightid = set_char(flightid, 1, " ")
        flightid_edit_letter = 1
    elseif flightid_edit_letter == 8 then
        -- For position 8, check if the character is empty or not
        local current_char = string.sub(flightid, 8, 8)
        if current_char ~= " " then
            -- If position 8 is not empty, delete it and stay at position 8
            flightid = set_char(flightid, 8, " ")
        else
            -- If position 8 is empty, delete position 7 and move to position 7
            flightid = set_char(flightid, 7, " ")
            flightid_edit_letter = 7
        end
    else
        -- For other positions (2 to 7), handle similarly
        local current_char = string.sub(flightid, flightid_edit_letter - 1, flightid_edit_letter - 1)
        if current_char ~= " " then
            -- If the character is not empty, delete it and stay at the same position
            flightid = set_char(flightid, flightid_edit_letter - 1, " ")
        end
        flightid_edit_letter = flightid_edit_letter - 1
    end

    -- Move the cursor left by 21px if not at position 1
    local cursor_x = 97 + (flightid_edit_letter - 1) * 21
    move(image_cursor, cursor_x, 160)

    -- Update the display with the modified flightid
    txt_set(txt_flightid, flightid)
end

function push_done()
    print("Flight ID was set to "..flightid)
    powerstate = 2
    fltid_am_visible(false)  -- Hide A-M keyboard if active
    fltid_nz_visible(false)  -- Hide N-Z keyboard if active
    print("Instrument boot complete")
end





function fltid_am_init()
  -- Should be executed once on startup by the logic.lua
  image_fltid_am = img_add_fullscreen("fltid_am.png")
  button_a = button_add("empty.png", "pushed_a.png", 551,5,83,73, nofunction, function() push_letter("A") end)
  button_b = button_add("empty.png", "pushed_b.png", 652,5,83,73, nofunction, function() push_letter("B") end)
  button_c = button_add("empty.png", "pushed_c.png", 753,5,83,73, nofunction, function() push_letter("C") end)
  button_d = button_add("empty.png", "pushed_d.png", 854,5,83,73, nofunction, function() push_letter("D") end)
  button_e = button_add("empty.png", "pushed_e.png", 551,106,83,73, nofunction, function() push_letter("E") end)
  button_f = button_add("empty.png", "pushed_f.png", 652,106,83,73, nofunction, function() push_letter("F") end)
  button_g = button_add("empty.png", "pushed_g.png", 753,106,83,73, nofunction, function() push_letter("G") end)
  button_h = button_add("empty.png", "pushed_h.png", 854,106,83,73, nofunction, function() push_letter("H") end)
  button_i = button_add("empty.png", "pushed_i.png", 509,205,83,73, nofunction, function() push_letter("I") end)
  button_j = button_add("empty.png", "pushed_j.png", 610,205,83,73, nofunction, function() push_letter("J") end)
  button_k = button_add("empty.png", "pushed_k.png", 711,205,83,73, nofunction, function() push_letter("K") end)
  button_l = button_add("empty.png", "pushed_l.png", 812,205,83,73, nofunction, function() push_letter("L") end)
  button_m = button_add("empty.png", "pushed_m.png", 913,205,83,73, nofunction, function() push_letter("M") end)
  button_backspace = button_add("empty.png", "pushed_backspace.png", 413,113,81,57, nofunction, push_backspace)    
  button_done = button_add("empty.png", "pushed_done.png", 366,5,124,34, nofunction, push_done)   
  button_usetail = button_add("empty.png", "pushed_usetail.png", 157,5,182,34,nofunction, usetail)
  button_nz = button_add("empty.png", "pushed_nz.png", 413, 205, 83, 73, nofunction, function()  
      fltid_am_visible(false)  -- Hide A-M keyboard
      fltid_nz_visible(true)   -- Show N-Z keyboard
      fltid_123_visible(false)  -- Hide 123 keyboard
  end)
  button_123 = button_add("empty.png", "pushed_123.png", 211, 205, 83, 73, nofunction, function()  
      fltid_am_visible(false)   -- Hide A-M keyboard
      fltid_nz_visible(false)   -- Hide N-Z keyboard
      fltid_123_visible(true)  -- Show 123 keyboard
  end)
  txt_flightid = txt_add(flightid, "font:Menlo-Regular.ttf; size:40; color: #13ff00; halign:left;", 97, 127, 237, 33)
end

function fltid_am_visible(is_visible)
  -- Show/hide the keyboard image
  visible(image_fltid_am, is_visible)
  visible(txt_flightid, is_visible)

  -- Hide/Show all buttons to disable interaction
  visible(button_a, is_visible)
  visible(button_b, is_visible)
  visible(button_c, is_visible)
  visible(button_d, is_visible)
  visible(button_e, is_visible)
  visible(button_f, is_visible)
  visible(button_g, is_visible)
  visible(button_h, is_visible)
  visible(button_i, is_visible)
  visible(button_j, is_visible)
  visible(button_k, is_visible)
  visible(button_l, is_visible)
  visible(button_m, is_visible)
  visible(button_backspace, is_visible)
  visible(button_done, is_visible)
  visible(button_usetail, is_visible)
  visible(button_nz, is_visible)
  visible(button_123, is_visible)
end

