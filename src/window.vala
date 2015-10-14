// -*- Mode: vala; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4 -*-
//
// Copyright (c) 2013 Giovanni Campagna <scampa.giovanni@gmail.com>
//
// Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//   * Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//   * Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//   * Neither the name of the GNOME Foundation nor the
//     names of its contributors may be used to endorse or promote products
//     derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[GtkTemplate (ui = "/com/example/Gtk/ValaApplication/main.ui")]
class MainWindow : Gtk.ApplicationWindow {
    [GtkChild]
    Gtk.Grid main_grid;

    [GtkChild]
    Gtk.SearchBar main_search_bar;

    [GtkChild]
    Gtk.SearchEntry main_search_entry;

    [GtkChild]
    Gtk.ToggleButton search_active_button;

    public bool search_active { get; set; default = false; }
	private MainView _view;

    public MainWindow (Gtk.Application app) {
		Object (application: app, title: GLib.Environment.get_application_name(),
				default_width: 640, default_height: 480);

		var action = new GLib.SimpleAction ("new", null);
		action.activate.connect (() => { this._new (); });

		action = new GLib.SimpleAction ("about", null);
		action.activate.connect (() => { this._about (); });

		action = new GLib.SimpleAction.stateful (
			"search-active",
			GLib.VariantType.BOOLEAN,
			new GLib.Variant.boolean (false));
		// action.activate.connect (() => { this._toggle_search (); });

        this.bind_property ("search-active", this.search_active_button, "active",
							GLib.BindingFlags.SYNC_CREATE |
							GLib.BindingFlags.BIDIRECTIONAL);
        this.bind_property ("search-active", this.main_search_bar, "search-mode-enabled",
							GLib.BindingFlags.SYNC_CREATE |
							GLib.BindingFlags.BIDIRECTIONAL);
        this.main_search_bar.connect_entry (this.main_search_entry);

        this._view = new MainView ();
        this._view.visible_child_name = (GLib.Random.double_range (0.0, 1.0) <= 0.5) ? "one" : "two";
        this.main_grid.add (this._view);
        this.main_grid.show_all ();

        // Due to limitations of gobject-introspection wrt GdkEvent and GdkEventKey,
        // this needs to be a signal handler
        this.key_press_event.connect (this._handle_key_press);
    }

    bool _handle_key_press (Gdk.Event ev) {
        return this.main_search_bar.handle_event(ev);
    }

    void _new () {
        message ("%s", _("New something"));
    }

    void _about () {
		string[] authors = {
			"Giovanni Campagna <gcampagna@src.gnome.org>"
		};

        var dialog = new Gtk.AboutDialog ();
		dialog.set_authors (authors);
		dialog.set_translator_credits (_("translator-credits"));
		dialog.set_program_name (_("Vala Application"));
		dialog.set_comments (_("Demo Vala Application and template"));
		dialog.set_copyright ("Copyright 2013 The gjs developers");
		dialog.set_license_type (Gtk.License.GPL_2_0);
		dialog.set_logo_icon_name ("com.example.Gtk.ValaApplication");
		dialog.set_version (Config.PACKAGE_VERSION);
		dialog.set_website ("http://www.example.com/gtk-vala-app/");
		dialog.set_wrap_license (true);

		dialog.set_modal (true);
		dialog.set_transient_for (this);

        dialog.show();
        dialog.response.connect(() => { dialog.destroy(); });
    }
}

class MainView : Gtk.Stack {

	public MainView () {
        Object (hexpand: true, vexpand: true);
	}

	GLib.Settings _settings;
	Gtk.Button _button_one;

	construct {
        this._settings = new GLib.Settings (Config.PACKAGE_NAME);

        this._button_one = this.add_page ("one", _("First page"), "");
        this._button_one.clicked.connect(() => {
				this.visible_child_name = "two";
			});
        this.sync_label ();
        this._settings.changed["show-exclamation-mark"].connect(this.sync_label);

        var two = this.add_page ("two", _("Second page"), _("What did you expect?"));
        two.clicked.connect(() => { this.visible_child_name = "one"; });
    }

    Gtk.Button add_page (string name, string label, string button) {
        var label_widget = new Gtk.Label (label);
        label_widget.get_style_context ().add_class ("big-label");
        var button_widget = new Gtk.Button.with_label (button);

        var grid = new Gtk.Grid ();
		grid.set_orientation (Gtk.Orientation.VERTICAL);
		grid.set_halign (Gtk.Align.CENTER);
		grid.set_valign (Gtk.Align.CENTER);
        grid.add (label_widget);
        grid.add (button_widget);

        this.add_named (grid, name);
        return button_widget;
    }

    void sync_label () {
        if (this._settings.get_boolean ("show-exclamation-mark"))
            this._button_one.set_label (_("Hello, world!"));
        else
            this._button_one.set_label (_("Hello world"));
    }
}
