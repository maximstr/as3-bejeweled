package lv.max.bejeweled.bejeweled.gameplay
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;

	import lv.max.bejeweled.bejeweled.gems.Gem;
	import lv.max.bejeweled.bejeweled.gems.GemPool;
	import lv.max.bejeweled.bejeweled.gems.GemPositionUpdate;

	public class LevelData
	{
		private var gemTypeList:Vector.<int>=new Vector.<int>();
		private var gemList:Vector.<Gem>;
		private var colCount:int, rowCount:int;

		public function LevelData(colCount:int, rowCount:int, gemTypeList:Vector.<int>)
		{
			this.gemTypeList=gemTypeList;
			this.colCount=colCount;
			this.rowCount=rowCount;
		}

		public function generateNewGemSet():void
		{
			gemList=generateRandomGemSet();
			var winSet:Vector.<Vector.<Gem>>=getWinCombinationList();
			var tryCount:int=0;

			while (winSet.length > 0 || isGameOverState())
			{
				removeWinCombinations(winSet);
				winSet=getWinCombinationList();

				if (tryCount++ > 1000)
				{
					throw new IllegalOperationError("Cant generate uniq gem field >1000");
				}
			}
		}

		private function removeWinCombinations(winList:Vector.<Vector.<Gem>>):void
		{
			for each (var gemLine:Vector.<Gem> in winList)
			{
				var randomIndex:int=int(Math.random() * gemLine.length);
				var gem:Gem=gemLine[randomIndex];
				changeGemToAnotherType(gem);
			}
		}

		private function changeGemToAnotherType(oldGem:Gem):Boolean
		{
			var pos:int=gemList.indexOf(oldGem);
			var newGem:Gem=getRandomGem(oldGem.getGemType());
			if (pos >= 0)
			{
				newGem.clonePosition(oldGem);
				gemList[pos]=newGem;
				GemPool.getInstance().pushGem(oldGem);
				return true;
			}
			return false;
		}

		private function generateRandomGemSet():Vector.<Gem>
		{
			var gemList:Vector.<Gem>=new Vector.<Gem>();

			for (var i:int=0; i < colCount; i++)
			{
				for (var j:int=0; j < rowCount; j++)
				{
					var gem:Gem=getRandomGem();
					gem.setCol(i);
					gem.setRow(j);
					gemList.push(gem);
				}
			}

			return gemList;
		}

		public function getWinCombinationList():Vector.<Vector.<Gem>>
		{
			var winList:Vector.<Vector.<Gem>>=new Vector.<Vector.<Gem>>;
			var colList:Vector.<Vector.<Gem>>=getColumnList();
			var rowList:Vector.<Vector.<Gem>>=getRowList();
			var tmpWinList:Vector.<Vector.<Gem>>;

			for each (var oneColumn:Vector.<Gem> in colList)
			{
				if (oneColumn && oneColumn.length > 0)
				{
					tmpWinList=getOneLineWinCombinationList(oneColumn);
					for each (var cvg:Vector.<Gem> in tmpWinList)
					{
						winList.push(cvg);
					}
				}
			}

			for each (var oneRow:Vector.<Gem> in rowList)
			{
				if (oneRow && oneRow.length > 0)
				{
					tmpWinList=getOneLineWinCombinationList(oneRow);
					for each (var rvg:Vector.<Gem> in tmpWinList)
					{
						winList.push(rvg);
					}
				}
			}

			return winList;
		}

		public function getOneLineWinCombinationList(gemLine:Vector.<Gem>):Vector.<Vector.<Gem>>
		{
			var winLine:Vector.<Vector.<Gem>>=new Vector.<Vector.<Gem>>();
			var checkList:Vector.<Gem>=new Vector.<Gem>();
			var i:int, gem:Gem, gemPass:Boolean;

			for (i=0; i < gemLine.length; i++)
			{
				gem=gemLine[i];
				if (gem)
				{
					if (checkList.length > 0)
					{
						gemPass=gem.getGemType() == checkList[checkList.length - 1].getGemType();
						if (gemPass)
						{
							checkList.push(gem);
						}
						else
						{
							if (checkList.length > 2)
							{
								winLine.push(checkList.concat());
							}
							checkList.splice(0, checkList.length, gem);
						}
					}
					else
					{
						checkList.push(gem);
					}
				}
				else
				{
					checkList.splice(0, checkList.length);
				}
			}
			if (checkList.length > 2)
			{
				winLine.push(checkList.concat());
			}

			return winLine;
		}

		public function getColumnList():Vector.<Vector.<Gem>>
		{
			var colList:Vector.<Vector.<Gem>>=new Vector.<Vector.<Gem>>(colCount);
			var col:int, row:int;
			for each (var gem:Gem in gemList)
			{
				col=gem.getCol();
				row=gem.getRow();

				if (!colList[col])
				{
					colList[col]=new Vector.<Gem>(rowCount);
				}
				colList[col][row]=gem;
			}
			return colList;
		}

		private function getRowList():Vector.<Vector.<Gem>>
		{
			var rowList:Vector.<Vector.<Gem>>=new Vector.<Vector.<Gem>>(rowCount);
			var col:int, row:int;
			for each (var gem:Gem in gemList)
			{
				col=gem.getCol();
				row=gem.getRow();

				if (!rowList[row])
				{
					rowList[row]=new Vector.<Gem>(colCount);
				}
				rowList[row][col]=gem;
			}
			return rowList;
		}

		private function getRandomGem(exceptGemType:int=-1):Gem
		{
			var gemType:int;
			do
			{
				gemType=gemTypeList[int(Math.random() * gemTypeList.length)];
			} while (gemType == exceptGemType)

			return GemPool.getInstance().popGem(gemType);
		}

		public function removeGems(gemRemoveList:Vector.<Gem>):void
		{
			for each (var gem:Gem in gemRemoveList)
			{
				var gemPos:int=gemList.indexOf(gem);
				if (gemPos >= 0)
				{
					gemList.splice(gemPos, 1);
					GemPool.getInstance().pushGem(gem);
				}
				else
				{
//					throw new IllegalOperationError("try to remove gem out of gemList:" + gem);
				}
			}
		}

		public function getGemPositionUpdateList():Vector.<GemPositionUpdate>
		{
			var gemUpdateList:Vector.<GemPositionUpdate>=new Vector.<GemPositionUpdate>();
			var downCellCount:int;
			var gemColList:Vector.<Vector.<Gem>>=getColumnList();
			for each (var gemCol:Vector.<Gem> in gemColList)
			{
				if (gemCol)
				{
					downCellCount=0;
					for (var i:int=gemCol.length - 1; i >= 0; i--)
					{
						var gem:Gem=gemCol[i];
						if (!gem)
						{
							downCellCount++;
						}
						else
						{
							if (downCellCount > 0)
							{
								var newPosition:Point=gem.getGemPosition();
								newPosition.y+=downCellCount;
								gemUpdateList.push(new GemPositionUpdate(gem, newPosition));
							}
						}
					}
				}
			}
			return gemUpdateList;
		}

		public function fillGemGaps():Vector.<Gem>
		{
			var newGemList:Vector.<Gem>=new Vector.<Gem>();
			var colList:Vector.<Vector.<Gem>>=getColumnList();

			for (var col:int=0; col < colCount; col++)
			{
				var column:Vector.<Gem>=colList[col] ? colList[col] : new Vector.<Gem>(rowCount);
				for (var row:int=0; row < rowCount; row++)
				{
					if (!column[row])
					{
						var newGem:Gem=getRandomGem();
						newGem.setCol(col);
						newGem.setRow(row);
						gemList.push(newGem);
						newGemList.push(newGem);
					}
				}
			}

			return newGemList;
		}

		public function isGameOverState():Boolean
		{
			function isGemInVerticalLine(c:int, r:int, gemType:int, checkSide:int):Boolean
			{
				for (var i:int=r; i < r + 3; i++)
					if (i >= 0 && i < rowCount)
						if (gems[c][i] == gemType)
							return true;
				if (checkSide < 0 && c > 0 && gems[c - 1][r + 1] == gemType)
					return true;
				if (checkSide > 0 && c < colCount - 1 && gems[c + 1][r + 1] == gemType)
					return true;
				return false;
			}
			function isGemInHorizontalLine(c:int, r:int, gemType:int, checkSide:int):Boolean
			{
				for (var i:int=c; i < c + 3; i++)
					if (i >= 0 && i < colCount)
						if (gems[i][r] == gemType)
							return true;
				if (checkSide < 0 && r > 0 && gems[c + 1][r - 1] == gemType)
					return true;
				if (checkSide > 0 && r < colCount - 1 && gems[c + 1][r + 1] == gemType)
					return true;
				return false;
			}

			var gems:Vector.<Vector.<int>>=getColumnTypeList();
			var g0:int, g1:int, g2:int, i:int;

			for (var col:int=0; col < colCount; col++)
			{
				for (var row:int=0; row < rowCount; row++)
				{
					if (col > 0 && col < colCount - 1)
					{
						g0=gems[col - 1][row];
						g1=gems[col + 0][row];
						g2=gems[col + 1][row];

						if (g0 == g1 && isGemInVerticalLine(col + 1, row - 1, g0, 1))
						{
							trace('no game over ' + col + ':' + row);
							return false;
						}
						if (g0 == g2 && isGemInVerticalLine(col + 0, row - 1, g0, 0))
						{
							trace('no game over ' + col + ':' + row);
							return false;
						}
						if (g1 == g2 && isGemInVerticalLine(col - 1, row - 1, g1, -1))
						{
							trace('no game over ' + col + ':' + row);
							return false;
						}
					}

					if (row > 0 && row < rowCount - 1)
					{
						g0=gems[col][row - 1];
						g1=gems[col][row + 0];
						g2=gems[col][row + 1];

						if (g0 == g1 && isGemInHorizontalLine(col - 1, row + 1, g0, 1))
						{
							trace('no game over ' + col + ':' + row);
							return false;
						}
						if (g0 == g2 && isGemInHorizontalLine(col - 1, row + 0, g0, 0))
						{
							trace('no game over ' + col + ':' + row);
							return false;
						}
						if (g1 == g2 && isGemInHorizontalLine(col - 1, row - 1, g1, -1))
						{
							trace('no game over ' + col + ':' + row);
							return false;
						}
					}
				}
			}

			return true;
		}

		private function getColumnTypeList():Vector.<Vector.<int>>
		{
			var colList:Vector.<Vector.<int>>=new Vector.<Vector.<int>>(colCount);
			var col:int, row:int;
			for each (var gem:Gem in gemList)
			{
				col=gem.getCol();
				row=gem.getRow();

				if (!colList[col])
				{
					colList[col]=new Vector.<int>(rowCount);
				}
				colList[col][row]=gem.getGemType();
			}
			return colList;
		}

	}
}
