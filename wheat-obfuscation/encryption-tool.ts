import * as crypto from 'crypto';
import * as fs from 'fs';
import * as path from 'path';

class SymmetricEncryptor {
	
	// THIS KEY NEEDS TO MATCH THE KEY IN THE VSCODE EXTENSION
	private key : string = "b3d93477f35b5b55f23218de7b5f48b3"; 
	
	encrypt(plainText : string) {
		const iv = crypto.randomBytes(16);
		const cipher = crypto.createCipheriv('aes-256-cbc', this.key, iv);
		let encryptedText = cipher.update(plainText, 'utf8', 'hex');
		encryptedText += cipher.final('hex');
		return iv.toString('hex') + encryptedText;
	}

	decrypt(encryptedText : string) {
		const iv = Buffer.from(encryptedText.slice(0, 32), 'hex');
		const decipher = crypto.createDecipheriv('aes-256-cbc', this.key, iv);
		let decryptedText = decipher.update(encryptedText.slice(32), 'hex', 'utf8');
		decryptedText += decipher.final('utf8');
		return decryptedText;
	}
}

function encryptFile(inputFilePath : string) {
    var e = new SymmetricEncryptor();
	// Read the input file
	const plainText = fs.readFileSync(inputFilePath, 'utf8');
	// Encrypt the plain text
	const encryptedText = e.encrypt(plainText);
    return encryptedText;
}

function processFilesInDirectory(directoryPath: string, destinationDirectory: string) {
    const files = fs.readdirSync(directoryPath);
    return files.forEach((file) => {

        const filePath = path.join(directoryPath, file);
        const encryptedText = encryptFile(filePath);
        fs.writeFileSync(path.join(destinationDirectory, file), encryptedText, 'utf8');
    });
}


const args = process.argv.slice(2);
if (args.length !== 2 || typeof args[0] !== 'string' || typeof args[1] !== 'string') {
    console.error('Usage : <input folder path> <destination folder>');
    process.exit(1);
}

const inputDir = args[0];
const destinationDirectory = args[1];

console.log(`Encrypting files in ${inputDir} and saving them to ${destinationDirectory}`);
processFilesInDirectory(inputDir, destinationDirectory);


