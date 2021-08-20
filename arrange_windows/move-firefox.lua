if string.match(get_window_name(), "Sign in to your account") then
	set_window_workspace(3);
	set_window_geometry(1980, 20, 1920, 1050);
	maximize();
end

if string.match(get_window_name(), "Simplenote") then
	set_window_workspace(3);
	set_window_geometry(0, 0, 1920, 1080);
	maximize();
end
 
