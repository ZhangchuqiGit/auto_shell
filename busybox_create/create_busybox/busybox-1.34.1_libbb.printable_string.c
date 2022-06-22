/* 
不知道从哪个版本开始 busybox 中的 shell 命令对中文输入即显示做了限制，
即使内核支持中文但在 shell 下也依然无法正确显示。
*/

#include "libbb.h"
#include "unicode.h"

const char* FAST_FUNC printable_string2(uni_stat_t *stats, const char *str)
{
	char *dst;
	const char *s;

	s = str;
	while (1) {
		unsigned char c = *s;
		if (c == '\0') {
			/* 99+% of inputs do not need conversion */
			if (stats) {
				stats->byte_count = (s - str);
				stats->unicode_count = (s - str);
				stats->unicode_width = (s - str);
			}
			return str;
		}
		if (c < ' ')
			break;
		/* 注释掉下面这个两行代码 */
		/* if (c >= 0x7f)
			break; */
		s++;
	}

#if ENABLE_UNICODE_SUPPORT
	dst = unicode_conv_to_printable(stats, str);
#else
	{
		char *d = dst = xstrdup(str);
		while (1) {
			unsigned char c = *d;
			if (c == '\0')
				break;
			/* 修改下面代码 */
			/* if (c < ' ' || c >= 0x7f) */
			if (c < ' ')
				*d = '?';
			d++;
		}
		if (stats) {
			stats->byte_count = (d - dst);
			stats->unicode_count = (d - dst);
			stats->unicode_width = (d - dst);
		}
	}
#endif
	return auto_string(dst);
}

const char* FAST_FUNC printable_string(const char *str)
{
	return printable_string2(NULL, str);
}
