# ساختار پروژه

این صفحه توضیحی درباره‌ی ساختار Text Forge و طراحی ماژولار آن است.

## روش توسعه

تمرکز در طراحی Text Forge بر پایه‌ی معماری ماژولار است، بنابراین همه‌چیز بر مبنای برنامه‌نویسی شی‌گرا پیاده‌سازی شده. هر ماژول باید **مستقل** باشد، ولی در عین حال بتواند **به‌خوبی با سایر ماژول‌ها تعامل داشته باشد** تا یک سیستم کامل شکل بگیرد. برای رسیدن به این هدف، ارتباط بین ماژول‌ها در Text Forge بر منطق ساده‌ای استوار است:

- دستورات به همه‌ی ماژول‌های مرتبط ارسال می‌شود. هر ماژول فقط مسئول اجرای دستوری است که به خودش مربوط می‌شود و سایر دستورات را نادیده می‌گیرد.
- سیگنال‌های رویدادی به SignalBus منتقل می‌شوند. اگر یک ماژول به سیگنالی نیاز داشته باشد، باید خودش آن را وصل کند.

## تعریف‌ها

- **Forge Port:** توابع یا سیگنال‌هایی که به ماژول‌ها امکان تعامل با Text Forge را می‌دهند.
- **Forge Bridge:** سیگنال‌ها (یا توابعی) که به ماژول‌های خارجی امکان تعامل با سایر ماژول‌ها را می‌دهند.

## هسته (Core)

همه‌چیز از اینجا شروع می‌شود. پس از بارگذاری Godot، هسته‌ی Text Forge اجرا می‌شود تا سایر بخش‌ها فعال شوند. این هسته شامل نود اصلی صحنه نیز هست که در تمام مدت اجرای برنامه ثابت باقی می‌ماند. هسته مستقیماً پورتی ندارد، ولی کلاس‌هایی را مدیریت می‌کند که دارای پورت هستند و به ماژول‌های خارجی امکان تعامل با هسته را می‌دهند.

**روش دسترسی:** `Global.get_core()`

## Extension Core

کلاسی برای افزونه‌ها. این ویژگی در حال حاضر آزمایشی و ناقص است.

## SignalBus

کلاسی است که مهم‌ترین سیگنال‌های برنامه در آن قرار دارند. تمام اجزای برنامه از طریق این سیگنال‌ها با یکدیگر در ارتباط هستند و تعامل با سایر بخش‌های Text Forge نیز از این مسیر انجام می‌شود.

**روش دسترسی:** `Signals`

### اجرای اسکریپت

دو نوع اسکریپت اکشن داریم: **Action Scripts** و **Multi Action Scripts**. اسکریپت‌های چندعملی (Multi) گزینه‌هایی با زیرمنو هستند که توانایی کنترل تمام آیتم‌های زیرمنو را به‌تنهایی دارند؛ پس برای اجرا نیاز به اطلاعات بیشتری دارند.

**سیگنال:** `run_script(script_id: int)` **Forge Port**  
**سیگنال:** `run_subscript(id: int, submenu: PopupMenu, rootmenu: String)` **Forge Port**

### بررسی وضعیت گزینه‌ها

برای فعال/غیرفعال کردن گزینه‌ها، SignalBus یک سیگنال دارد که به تمام اسکریپت‌های اکشن و چندعملی متصل است:

**سیگنال:** `check_options` **Forge Port**

### سیستم اعلان (Notification)

یک پورت اتصال برای ماژول‌های خارجی فراهم شده تا بتوانند قابلیت تعامل با سایر ماژول‌ها را اضافه کنند. سیگنال `notification` از طریق شناسه به ماژول هدف ارسال شده و می‌تواند اطلاعات را به‌صورت `Array` منتقل کند.

**سیگنال:** `notification(id: String, data: Array)` **Forge Bridge**

### سیگنال‌های دیگر

برخی سیگنال‌های خاص برای عملیات رایج:

- `close_file` **Forge Port**
- `open_file(path: String)` **Forge Port**
- `new_file` **Forge Port**
- `update_recent_files` **Forge Port** ← این سیگنال باعث فراخوانی تابعی در هسته می‌شود که منوی فایل‌های اخیر را از روی فایل داده مجدداً بارگذاری می‌کند.

و برخی سیگنال‌های داخلی:

- `caret_selected(index: int)`
- `mode_selected`

### ذخیره‌سازی و Callback

گاهی ویرایشگر نیاز دارد تغییرات را ذخیره کند و سپس عملی انجام دهد. در این موارد، SignalBus نقش حیاتی دارد:

- اسکریپت اکشن با `id` مشخص، `Signals.save_request(id)` را فراخوانی می‌کند و منتظر ادامه عملیات پس از ذخیره باقی می‌ماند.
- SignalBus یک دیالوگ تأیید برای ذخیره نشان می‌دهد:
    - اگر کاربر "ذخیره" را انتخاب کند:
        - اسکریپت ذخیره‌ی مرتبط، با `callback = id` اجرا می‌شود.
        - پس از ذخیره، اسکریپت سیگنال `Signals.save_finished(id)` را ارسال می‌کند.
        - SignalBus علامت ذخیره‌شدن را می‌زند و `run_script(id)` را فراخوانی می‌کند.
    - اگر کاربر "صرف‌نظر" کند، مستقیم `run_script(id)` ارسال می‌شود.
- اسکریپت اکشن فرمان اجرا را دریافت کرده و عملیات خود را آغاز می‌کند.

## GlobalAccess

کلاسی برای دسترسی سریع و ایمن به بخش‌های اصلی Text Forge.

- `get_core()` **Forge Port** ← مراجعه به بخش Core
- `get_editor()` **Forge Port** ← بازگرداندن نود اصلی ویرایشگر
- `get_editor_api()` **Forge Port** ← بازگرداندن EditorAPI برای مدیریت مودها
- `get_editor_text()` **Forge Port** ← متن فعلی ویرایشگر
- `get_file_name()` **Forge Port** ← نام فایل باز شده
- `get_file_path()` **Forge Port** ← مسیر فایل باز شده
- `get_scripts_node()` **Forge Port** ← نود والد اسکریپت‌ها
- `is_editor_disabled()` **Forge Port** ← بررسی فعال/غیرفعال بودن ویرایشگر
- `set_editor_disabled(disabled: bool)` **Forge Port** ← غیرفعال یا فعال کردن ویرایشگر
- `set_editor_text(text: String)` **Forge Port** ← تنظیم متن و بازگرداندن مکان‌نما به ابتدا
- `set_file_name(file_name: String)` **Forge Port** ← تنظیم نام فایل (بدون بارگذاری)
- `set_file_path(path: String)` **Forge Port** ← تنظیم مسیر فایل (بدون بارگذاری)

## ActionScript

کلاس پایه برای اسکریپت‌های اکشن. برای ساخت یک اسکریپت اکشن باید موارد زیر را بدانید:

- اسکریپت‌ها از پوشه‌ی `scripts/` و براساس `data/main_ui.ini` بارگذاری می‌شن. اگر گزینه‌ای در UI تعریف شده باشه و فایلی با همون نام (در حالت **snake_case**) توی `scripts/` وجود داشته باشه، اون اسکریپت بارگذاری می‌شه.
- آیتم‌های داخلی هر اسکریپت شامل ویژگی‌ها: `id, menu, need_file, action_shortcut` و توابع: `_ready, _check_option, _load_shortcut, _convert_event_to_key, run, _run_action`
- هسته تابع `run()` رو صدا می‌زنه، که خودش در صورت تطابق `id` تابع `_run_action()` رو اجرا می‌کنه.
- تابع `_ready()` به‌طور پیش‌فرض تابع `_load_shortcut()` رو اجرا می‌کنه؛ پس اگه می‌خوای override کنی، فراموش نکن دوباره اون رو صدا بزنی.
- اگر `need_file = true` باشه (پیش‌فرض `false`)، در صورت نبود فایل باز، گزینه در منو غیرفعال می‌شه.
- شورتکات‌ها از پوشه‌ی `shortcuts/` بارگذاری می‌شن. فایل باید هم‌نام با اسکریپت ولی با پسوند `.tres` باشه. نبودن فایل مشکلی ایجاد نمی‌کنه.
- شورتکات باید از نوع `Shortcut` باشه.
- منطق اصلی اکشنت رو داخل تابع `_run_action()` بنویس.
