return {
	["cap_style"] = {
		["PROJECTING"] = 3,
		["NOT_LAST"] = 0,
		["BUTT"] = 1,
		["ROUND"] = 2,
	},
	["gravity"] = {
		["SOUTH_EAST"] = 9,
		["SOUTH"] = 8,
		["NORTH"] = 2,
		["NORTH_WEST"] = 1,
		["STATIC"] = 10,
		["SOUTH_WEST"] = 7,
		["CENTER"] = 5,
		["EAST"] = 6,
		["BIT_FORGET"] = 0,
		["WIN_UNMAP"] = 0,
		["WEST"] = 4,
		["NORTH_EAST"] = 3,
	},
	["join_style"] = {
		["ROUND"] = 1,
		["MITER"] = 0,
		["BEVEL"] = 2,
	},
	["poly_shape"] = {
		["CONVEX"] = 2,
		["NONCONVEX"] = 1,
		["COMPLEX"] = 0,
	},
	["map_index"] = {
		["5"] = 7,
		["CONTROL"] = 2,
		["1"] = 3,
		["2"] = 4,
		["SHIFT"] = 0,
		["3"] = 5,
		["LOCK"] = 1,
		["4"] = 6,
	},
	["arc_mode"] = {
		["CHORD"] = 0,
		["PIE_SLICE"] = 1,
	},
	["access_control"] = {
		["DISABLE"] = 0,
		["ENABLE"] = 1,
	},
	["input_focus"] = {
		["FOLLOW_KEYBOARD"] = 3,
		["POINTER_ROOT"] = 1,
		["NONE"] = 0,
		["PARENT"] = 2,
	},
	["coord_mode"] = {
		["ORIGIN"] = 0,
		["PREVIOUS"] = 1,
	},
	["gx"] = {
		["OR"] = 7,
		["COPY"] = 3,
		["AND_REVERSE"] = 2,
		["XOR"] = 6,
		["AND"] = 1,
		["NOOP"] = 5,
		["OR_INVERTED"] = 13,
		["COPY_INVERTED"] = 12,
		["CLEAR"] = 0,
		["NAND"] = 14,
		["NOR"] = 8,
		["SET"] = 15,
		["AND_INVERTED"] = 4,
		["EQUIV"] = 9,
		["OR_REVERSE"] = 11,
		["INVERT"] = 10,
	},
	["clip_ordering"] = {
		["UNSORTED"] = 0,
		["YX_BANDED"] = 3,
		["YX_SORTED"] = 2,
		["Y_SORTED"] = 1,
	},
	["cw"] = {
		["BACK_PIXMAP"] = 1,
		["COLORMAP"] = 8192,
		["WIN_GRAVITY"] = 32,
		["CURSOR"] = 16384,
		["EVENT_MASK"] = 2048,
		["SAVE_UNDER"] = 1024,
		["OVERRIDE_REDIRECT"] = 512,
		["DONT_PROPAGATE"] = 4096,
		["BORDER_PIXMAP"] = 4,
		["BACKING_PLANES"] = 128,
		["BIT_GRAVITY"] = 16,
		["BACK_PIXEL"] = 2,
		["BORDER_PIXEL"] = 8,
		["BACKING_STORE"] = 64,
		["BACKING_PIXEL"] = 256,
	},
	["blanking"] = {
		["NOT_PREFERRED"] = 0,
		["PREFERRED"] = 1,
		["DEFAULT"] = 2,
	},
	["set_mode"] = {
		["INSERT"] = 0,
		["DELETE"] = 1,
	},
	["cursor_enum"] = {
		["XCB_CURSOR_NONE"] = 0,
	},
	["backing_store"] = {
		["ALWAYS"] = 2,
		["NOT_USEFUL"] = 0,
		["WHEN_MAPPED"] = 1,
	},
	["host_mode"] = {
		["DELETE"] = 1,
		["INSERT"] = 0,
	},
	["notify_detail"] = {
		["ANCESTOR"] = 0,
		["POINTER"] = 5,
		["VIRTUAL"] = 1,
		["NONE"] = 7,
		["POINTER_ROOT"] = 6,
		["NONLINEAR_VIRTUAL"] = 4,
		["INFERIOR"] = 2,
		["NONLINEAR"] = 3,
	},
	["font_enum"] = {
		["XCB_FONT_NONE"] = 0,
	},
	["circulate"] = {
		["RAISE_LOWEST"] = 0,
		["LOWER_HIGHEST"] = 1,
	},
	["grab_status"] = {
		["SUCCESS"] = 0,
		["NOT_VIEWABLE"] = 3,
		["FROZEN"] = 4,
		["ALREADY_GRABBED"] = 1,
		["INVALID_TIME"] = 2,
	},
	["atom_enum"] = {
		["MIN_SPACE"] = 43,
		["ITALIC_ANGLE"] = 55,
		["UNDERLINE_POSITION"] = 51,
		["ATOM"] = 4,
		["POINT"] = 21,
		["CUT_BUFFER5"] = 14,
		["PIXMAP"] = 20,
		["CUT_BUFFER6"] = 15,
		["PRIMARY"] = 1,
		["SUPERSCRIPT_Y"] = 48,
		["CUT_BUFFER7"] = 16,
		["X_HEIGHT"] = 56,
		["SECONDARY"] = 2,
		["CUT_BUFFER0"] = 9,
		["WINDOW"] = 33,
		["FAMILY_NAME"] = 64,
		["UNDERLINE_THICKNESS"] = 52,
		["END_SPACE"] = 46,
		["WM_CLIENT_MACHINE"] = 36,
		["WM_NAME"] = 39,
		["COPYRIGHT"] = 61,
		["RECTANGLE"] = 22,
		["VISUALID"] = 32,
		["STRIKEOUT_ASCENT"] = 53,
		["STRING"] = 31,
		["RESOURCE_MANAGER"] = 23,
		["CUT_BUFFER4"] = 13,
		["NOTICE"] = 62,
		["FULL_NAME"] = 65,
		["NORM_SPACE"] = 44,
		["RGB_DEFAULT_MAP"] = 27,
		["FONT"] = 18,
		["INTEGER"] = 19,
		["CARDINAL"] = 6,
		["BITMAP"] = 5,
		["WM_HINTS"] = 35,
		["RGB_GREEN_MAP"] = 29,
		["RESOLUTION"] = 60,
		["CURSOR"] = 8,
		["ANY"] = 0,
		["WM_TRANSIENT_FOR"] = 68,
		["WM_CLASS"] = 67,
		["WM_COMMAND"] = 34,
		["CUT_BUFFER1"] = 10,
		["ARC"] = 3,
		["POINT_SIZE"] = 59,
		["FONT_NAME"] = 63,
		["COLORMAP"] = 7,
		["CAP_HEIGHT"] = 66,
		["SUPERSCRIPT_X"] = 47,
		["WM_NORMAL_HINTS"] = 40,
		["NONE"] = 0,
		["RGB_GRAY_MAP"] = 28,
		["DRAWABLE"] = 17,
		["MAX_SPACE"] = 45,
		["CUT_BUFFER3"] = 12,
		["RGB_BEST_MAP"] = 25,
		["WM_ICON_SIZE"] = 38,
		["RGB_COLOR_MAP"] = 24,
		["WM_ICON_NAME"] = 37,
		["WM_ZOOM_HINTS"] = 42,
		["CUT_BUFFER2"] = 11,
		["RGB_RED_MAP"] = 30,
		["WM_SIZE_HINTS"] = 41,
		["WEIGHT"] = 58,
		["RGB_BLUE_MAP"] = 26,
		["STRIKEOUT_DESCENT"] = 54,
		["QUAD_WIDTH"] = 57,
		["SUBSCRIPT_X"] = 49,
		["SUBSCRIPT_Y"] = 50,
	},
	["grab"] = {
		["ANY"] = 0,
	},
	["visibility"] = {
		["UNOBSCURED"] = 0,
		["FULLY_OBSCURED"] = 2,
		["PARTIALLY_OBSCURED"] = 1,
	},
	["line_style"] = {
		["DOUBLE_DASH"] = 2,
		["SOLID"] = 0,
		["ON_OFF_DASH"] = 1,
	},
	["pixmap_enum"] = {
		["NONE"] = 0,
	},
	["fill_rule"] = {
		["EVEN_ODD"] = 0,
		["WINDING"] = 1,
	},
	["key_but_mask"] = {
		["CONTROL"] = 4,
		["LOCK"] = 2,
		["MOD_2"] = 16,
		["BUTTON_5"] = 4096,
		["BUTTON_4"] = 2048,
		["MOD_5"] = 128,
		["BUTTON_3"] = 1024,
		["BUTTON_2"] = 512,
		["BUTTON_1"] = 256,
		["MOD_3"] = 32,
		["MOD_1"] = 8,
		["MOD_4"] = 64,
		["SHIFT"] = 1,
	},
	["allow"] = {
		["SYNC_BOTH"] = 7,
		["SYNC_KEYBOARD"] = 4,
		["REPLAY_POINTER"] = 2,
		["SYNC_POINTER"] = 1,
		["REPLAY_KEYBOARD"] = 5,
		["ASYNC_BOTH"] = 6,
		["ASYNC_POINTER"] = 0,
		["ASYNC_KEYBOARD"] = 3,
	},
	["send_event_dest"] = {
		["ITEM_FOCUS"] = 1,
		["POINTER_WINDOW"] = 0,
	},
	["auto_repeat_mode"] = {
		["OFF"] = 0,
		["ON"] = 1,
		["DEFAULT"] = 2,
	},
	["subwindow_mode"] = {
		["INCLUDE_INFERIORS"] = 1,
		["CLIP_BY_CHILDREN"] = 0,
	},
	["kill"] = {
		["ALL_TEMPORARY"] = 0,
	},
	["gc"] = {
		["SUBWINDOW_MODE"] = 32768,
		["LINE_WIDTH"] = 16,
		["GRAPHICS_EXPOSURES"] = 65536,
		["TILE_STIPPLE_ORIGIN_Y"] = 8192,
		["TILE"] = 1024,
		["FILL_RULE"] = 512,
		["STIPPLE"] = 2048,
		["LINE_STYLE"] = 32,
		["CLIP_ORIGIN_X"] = 131072,
		["FOREGROUND"] = 4,
		["TILE_STIPPLE_ORIGIN_X"] = 4096,
		["DASH_LIST"] = 2097152,
		["CAP_STYLE"] = 64,
		["FONT"] = 16384,
		["CLIP_MASK"] = 524288,
		["JOIN_STYLE"] = 128,
		["DASH_OFFSET"] = 1048576,
		["CLIP_ORIGIN_Y"] = 262144,
		["ARC_MODE"] = 4194304,
		["FILL_STYLE"] = 256,
		["PLANE_MASK"] = 2,
		["FUNCTION"] = 1,
		["BACKGROUND"] = 8,
	},
	["kb"] = {
		["KEY_CLICK_PERCENT"] = 1,
		["AUTO_REPEAT_MODE"] = 128,
		["BELL_PERCENT"] = 2,
		["LED"] = 16,
		["BELL_PITCH"] = 4,
		["LED_MODE"] = 32,
		["BELL_DURATION"] = 8,
		["KEY"] = 64,
	},
	["fill_style"] = {
		["OPAQUE_STIPPLED"] = 3,
		["TILED"] = 1,
		["STIPPLED"] = 2,
		["SOLID"] = 0,
	},
	["exposures"] = {
		["ALLOWED"] = 1,
		["DEFAULT"] = 2,
		["NOT_ALLOWED"] = 0,
	},
	["color_flag"] = {
		["RED"] = 1,
		["BLUE"] = 4,
		["GREEN"] = 2,
	},
	["grab_mode"] = {
		["SYNC"] = 0,
		["ASYNC"] = 1,
	},
	["colormap_enum"] = {
		["XCB_COLORMAP_NONE"] = 0,
	},
	["mapping_status"] = {
		["SUCCESS"] = 0,
		["FAILURE"] = 2,
		["BUSY"] = 1,
	},
	["get_property_type"] = {
		["ANY"] = 0,
	},
	["query_shape_of"] = {
		["LARGEST_CURSOR"] = 0,
		["FASTEST_STIPPLE"] = 2,
		["FASTEST_TILE"] = 1,
	},
	["family"] = {
		["CHAOS"] = 2,
		["SERVER_INTERPRETED"] = 5,
		["DECNET"] = 1,
		["INTERNET_6"] = 6,
		["INTERNET"] = 0,
	},
	["window_enum"] = {
		["XCB_WINDOW_NONE"] = 0,
	},
	["screen_saver"] = {
		["RESET"] = 0,
		["ACTIVE"] = 1,
	},
	["back_pixmap"] = {
		["PARENT_RELATIVE"] = 1,
		["NONE"] = 0,
	},
	["close_down"] = {
		["RETAIN_TEMPORARY"] = 2,
		["RETAIN_PERMANENT"] = 1,
		["DESTROY_ALL"] = 0,
	},
	["stack_mode"] = {
		["ABOVE"] = 0,
		["OPPOSITE"] = 4,
		["BELOW"] = 1,
		["TOP_IF"] = 2,
		["BOTTOM_IF"] = 3,
	},
	["mapping"] = {
		["MODIFIER"] = 0,
		["KEYBOARD"] = 1,
		["POINTER"] = 2,
	},
	["image_order"] = {
		["MSB_FIRST"] = 1,
		["LSB_FIRST"] = 0,
	},
	["mod_mask"] = {
		["5"] = 128,
		["ANY"] = 32768,
		["3"] = 32,
		["LOCK"] = 2,
		["4"] = 64,
		["SHIFT"] = 1,
		["1"] = 8,
		["2"] = 16,
		["CONTROL"] = 4,
	},
	["prop_mode"] = {
		["REPLACE"] = 0,
		["PREPEND"] = 1,
		["APPEND"] = 2,
	},
	["config_window"] = {
		["SIBLING"] = 32,
		["WIDTH"] = 4,
		["HEIGHT"] = 8,
		["X"] = 1,
		["Y"] = 2,
		["STACK_MODE"] = 64,
		["BORDER_WIDTH"] = 16,
	},
	["property"] = {
		["NEW_VALUE"] = 0,
		["DELETE"] = 1,
	},
	["window_class"] = {
		["COPY_FROM_PARENT"] = 0,
		["INPUT_OUTPUT"] = 1,
		["INPUT_ONLY"] = 2,
	},
	["button_mask"] = {
		["4"] = 2048,
		["3"] = 1024,
		["2"] = 512,
		["ANY"] = 32768,
		["1"] = 256,
		["5"] = 4096,
	},
	["motion"] = {
		["HINT"] = 1,
		["NORMAL"] = 0,
	},
	["visual_class"] = {
		["STATIC_GRAY"] = 0,
		["GRAY_SCALE"] = 1,
		["DIRECT_COLOR"] = 5,
		["STATIC_COLOR"] = 2,
		["TRUE_COLOR"] = 4,
		["PSEUDO_COLOR"] = 3,
	},
	["place"] = {
		["ON_BOTTOM"] = 1,
		["ON_TOP"] = 0,
	},
	["colormap_state"] = {
		["UNINSTALLED"] = 0,
		["INSTALLED"] = 1,
	},
	["image_format"] = {
		["XY_BITMAP"] = 0,
		["Z_PIXMAP"] = 2,
		["XY_PIXMAP"] = 1,
	},
	["map_state"] = {
		["VIEWABLE"] = 2,
		["UNVIEWABLE"] = 1,
		["UNMAPPED"] = 0,
	},
	["font_draw"] = {
		["RIGHT_TO_LEFT"] = 1,
		["LEFT_TO_RIGHT"] = 0,
	},
	["button_index"] = {
		["1"] = 1,
		["2"] = 2,
		["5"] = 5,
		["3"] = 3,
		["ANY"] = 0,
		["4"] = 4,
	},
	["time"] = {
		["CURRENT_TIME"] = 0,
	},
	["event_mask"] = {
		["BUTTON_RELEASE"] = 8,
		["BUTTON_PRESS"] = 4,
		["FOCUS_CHANGE"] = 2097152,
		["KEYMAP_STATE"] = 16384,
		["BUTTON_1_MOTION"] = 256,
		["KEY_RELEASE"] = 2,
		["EXPOSURE"] = 32768,
		["BUTTON_5_MOTION"] = 4096,
		["BUTTON_MOTION"] = 8192,
		["VISIBILITY_CHANGE"] = 65536,
		["KEY_PRESS"] = 1,
		["BUTTON_2_MOTION"] = 512,
		["NO_EVENT"] = 0,
		["POINTER_MOTION"] = 64,
		["ENTER_WINDOW"] = 16,
		["PROPERTY_CHANGE"] = 4194304,
		["SUBSTRUCTURE_REDIRECT"] = 1048576,
		["STRUCTURE_NOTIFY"] = 131072,
		["LEAVE_WINDOW"] = 32,
		["RESIZE_REDIRECT"] = 262144,
		["POINTER_MOTION_HINT"] = 128,
		["OWNER_GRAB_BUTTON"] = 16777216,
		["SUBSTRUCTURE_NOTIFY"] = 524288,
		["BUTTON_3_MOTION"] = 1024,
		["BUTTON_4_MOTION"] = 2048,
		["COLOR_MAP_CHANGE"] = 8388608,
	},
	["colormap_alloc"] = {
		["ALL"] = 1,
		["NONE"] = 0,
	},
	["notify_mode"] = {
		["GRAB"] = 1,
		["UNGRAB"] = 2,
		["WHILE_GRABBED"] = 3,
		["NORMAL"] = 0,
	},
	["led_mode"] = {
		["ON"] = 1,
		["OFF"] = 0,
	},
}
