export class VariableEngine {
  static process(source: string): string {
    const vars: { [key: string]: string } = {};
    const lines = source.split('\n');
    const output: string[] = [];

    // This looks for: int name = 5;
    const varPattern = /int\s+(\w+)\s*=\s*(\d+)\s*;/;

    for (let line of lines) {
      const match = line.match(varPattern);
      if (match) {
        // We found a variable! Save it.
        vars[match[1]] = match[2]; 
        // We don't add this line to 'output', effectively deleting it 
        // so the real Jeroo compiler doesn't get confused by the 'int' keyword.
      } else {
        let cleanLine = line;
        // Search the line for any variable names we saved and replace them with the number.
        for (let name in vars) {
          const regex = new RegExp(`\\b${name}\\b`, 'g');
          cleanLine = cleanLine.replace(regex, vars[name]);
        }
        output.push(cleanLine);
      }
    }
    return output.join('\n');
  }
}