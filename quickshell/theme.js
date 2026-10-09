// ~/.config/quickshell/snow/theme.js
// Dynamic color palette bridge for Quickshell
.pragma library

var colors = {
    bg: "#1e1e2e",
    surface: "#252636",
    surfaceHi: "#2a2b3c",
    text: "#ffffff",
    muted: "#8b90a6",
    accent: "#6366f1",
    warn: "#fbbf24",
    danger: "#ef4444",
    success: "#4ade80"
};

function updateTheme(newColors) {
    if (newColors) {
        for (var k in newColors) {
            if (colors.hasOwnProperty(k)) {
                colors[k] = newColors[k];
            }
        }
    }
}
