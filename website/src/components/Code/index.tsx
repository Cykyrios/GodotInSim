import type { ReactNode } from 'react';
import { Highlight } from "prism-react-renderer";
import { useColorMode, useThemeConfig } from "@docusaurus/theme-common"

// Inline code component with Prism syntax highlighting. Named "Code" because "InlineCode"
// would be pretty long when added both before and after the code. Of course, this means
// the component has a name which is very similar to the html <code> tag instead.
export default function Code({children, lang = "gdscript"}): ReactNode {
  const {colorMode} = useColorMode();
  const {prism} = useThemeConfig();
  const theme = colorMode === "dark" ? prism.darkTheme : prism.theme;
  
  return (
    <Highlight
      code={children}
      language={lang as any}
      theme={theme}
    >
    {({tokens, getTokenProps}) => (
      <code className={`language-${lang} prism-code`}>
        {tokens[0]?.map((token, key) => (
          <span key={key} {...getTokenProps({token})} />
        ))}
      </code>
    )}
    </Highlight>
  );
};
