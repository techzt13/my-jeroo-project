export class VariableEngine {
  static process(source: string): string {
    const vars: { [key: string]: string } = {};
    const lines = source.split(/\r?\n/);
    const output: string[] = [];

    const varPattern = /^\s*(?:dim|int|var)\s+(\w+)(?:\s+as\s+\w+)?\s*=\s*(\d+).*/i;

    for (let line of lines) {
      const match = line.match(varPattern);
      
      if (match) {
        vars[match[1]] = match[2]; 
        // --- CHANGE HERE ---
        // We push NOTHING. No empty string, no space. 
        // This deletes the line from existence.
      } else {
        let cleanLine = line;
        const sortedNames = Object.keys(vars).sort((a, b) => b.length - a.length);
        
        for (let name of sortedNames) {
          const regex = new RegExp(`\\b${name}\\b`, 'gi');
          cleanLine = cleanLine.replace(regex, vars[name]);
        }
        
        // Only push the line if it's not just whitespace 
        // (This cleans up any other weird empty lines)
        if (cleanLine.trim() !== "") {
            output.push(cleanLine);
        }
      }
    }
    return output.join('\n');
  }
}