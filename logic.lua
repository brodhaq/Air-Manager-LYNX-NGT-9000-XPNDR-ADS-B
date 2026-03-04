--graphics initialization
canvas_background = canvas_add(0, 0, 1000, 285, function() --black background
   _rect(0,0,1000,285)
   _fill("black")
end)
image_splashscreen = img_add_fullscreen("splashscreen.png")
visible(image_splashscreen, false)
image_systemstatus = img_add_fullscreen("systemstatus.png")
visible(image_systemstatus, false)
image_cursor = img_add("cursor.png", 97, 160, 24, 3) --cursor for flight ID page
visible (image_cursor, false)

--logics initialization
function initialize()
    powerstate = 0 --0 = off, 1 = boot selftest, 2 = on
    prev_powerstate = 0  -- Track previous state to prevent redundant assignments
    local timer_boot1 --timer for boot sequence blak page
    local timer_boot2 --timer for boot sequence spla shcreen
    local timer_boot3 --timer for boot sequence system status
    flightid = "        " --initial flight id is eight blank spaces
    title_tailnumber = user_prop_add_string("Tail number", "OEFDX", "Default tail number for the Flight ID page.")
    choice_boot = user_prop_add_enum("Boot type", "Realistic,Development", "Realistic", "Boot time and power (not) required")
    if user_prop_get(choice_boot) == "Realistic" then
        boot_time = 9000
        min_volts = 8
    else
        boot_time = 100
        min_volts = 0
        end  
    fltid_am_init() --flight id A-M keyboard initialization
    fltid_am_visible(false) --flight id A-M keyboard hide
    fltid_nz_init() --flight id N-Z keyboard initialization
    fltid_nz_visible(false) --flight id N-Z keyboard hide
    fltid_123_init() --flight id 123 keyboard initialization
    fltid_123_visible(false) --flight id 123 keyboard hide
    local cursor_timer_id --timer for cursor blinking on flight id page
    flightid_edit_letter = 1 --which flight ID letter are we editing now? initializated for first letter
end
--instrument logics
function blink_cursor()
    cursor_timer_id = timer_start(300, 300, function()  
        -- Toggle the cursor visibility 
        if powerstate == 1 then
            cursor_visible = not cursor_visible
            visible(image_cursor, cursor_visible)  -- Update visibility
        else
            timer_stop(cursor_timer_id)
            visible(image_cursor, false)
        end
    end)
end

function boot_sequence()
    powerstate = 1
    -- Start a timer that waits on blank page before showing the splashscreen
    timer_boot1 = timer_start(boot_time/2, 0, function()
        -- Show splashscreen for x seconds
        visible(image_splashscreen, true)
        timer_boot2 = timer_start(boot_time, 0, function()
            -- Hide splashscreen and show system status for x seconds
            visible(image_splashscreen, false)
            visible(image_systemstatus, true)
            timer_boot3 = timer_start(boot_time, 0, function()
                -- Hide system status and show something else (to be added)
                visible(image_systemstatus, false)
                -- Display the Flight ID page here, wait for user action to continue
                fltid_am_visible(true)
                blink_cursor()
            end)
        end)
    end)
end

function instrument_shutdown()
        powerstate = 0 
        timer_stop(timer_boot1) --abort boot sequence if running
        timer_stop(timer_boot2) --abort boot sequence if running
        timer_stop(timer_boot3) --abort boot sequence if running
        visible(image_splashscreen, false)
        visible(image_systemstatus, false)
        flightid = "        " --erase the set flight-id
        flightid_edit_letter = 1
        fltid_am_visible(false)
        fltid_nz_visible(false) --flight id N-Z keyboard hide
        fltid_123_visible(false) --flight id 123 keyboard hide
        timer_stop(cursor_timer_id)
        visible(image_cursor, false)
end

function new_power(volts_1) 
    if volts_1 >= min_volts then
        if powerstate == 0 then
            boot_sequence() --power on the instrument via the boot selftest
        end
    else
        if powerstate ~= 0 then
            instrument_shutdown() --shutdown the instrument  
        end
    end

    -- Only do if powerstate actually changed
    if powerstate ~= prev_powerstate then
        prev_powerstate = powerstate  -- Update tracking variable
    end
end
initialize()--call the initialization function on the instrument boot
new_power(0) --this is here in order to run the new_power once so that the instrument boots in the Quick boot type even when no power is provided.
-- simulator connection
xpl_dataref_subscribe("skyvan/electrical/essential_services_volts_1", "FLOAT", new_power)

--notes
--currently it is powered by essential services bus 1, maybe change to where it needs to be wired