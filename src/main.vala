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

class MyApplication : Gtk.Application
{
    public MyApplication () {
        Object (application_id: Config.PACKAGE_NAME);
    }

    construct {
        GLib.Environment.set_application_name (_("My Vala Application"));
    }

    public override void startup () {
        base.startup ();

        var provider = new Gtk.CssProvider ();
        provider.load_from_file (GLib.File.new_for_uri (
            "resource:///com/example/Gtk/ValaApplication/application.css"));
        Gtk.StyleContext.add_provider_for_screen (
            Gdk.Screen.get_default (),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

        var action = new GLib.SimpleAction ("quit", null);
        action.activate.connect (() => { this.quit (); });

        var builder = new Gtk.Builder ();
        builder.add_from_resource (
            "/com/example/Gtk/ValaApplication/app-menu.ui");

        var menu = (GLib.MenuModel) builder.get_object ("app-menu");
        this.set_app_menu (menu);

        message ("%s", _("My Vala Application started"));
    }

    public override void activate () {
        (new MainWindow (this)).show ();
    }

    public override void shutdown () {
        message ("%s", _("My Vala Application exiting"));
        base.shutdown ();
    }
}

public int main (string[] args) {
    return (new MyApplication ()).run (args);
}
