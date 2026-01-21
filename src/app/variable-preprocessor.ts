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
        vars[match[1]] = match[2]; // Save the variable name and value
      } else {
        let cleanLine = line;
        // Replace variable names with their numbers in the remaining code
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